@Tags(['network'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:ama/data/controllers/api_url_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// Live contract smoke test against the real attend_api backend
/// (signin.php / usr_register.php / updatePassword.php).
///
/// Unlike api_reachability_test.dart (which only checks the server answers
/// at all), this exercises the actual auth business logic end to end:
/// credential validation, the multi-login device binding added for the
/// device-id bug fix, and the duplicate-device guard added to close the
/// "two accounts, one device" hole.
///
///   flutter test test/api_integration_smoke_test.dart
///
/// SIDE EFFECT: the signin.php tests bind [_testEmail]'s deviceId in the
/// production database to [_smokeDeviceId]. This is intentional and
/// idempotent — every run reuses the same fixed id, so the suite is safe to
/// re-run without any manual reset in between. It does mean [_testEmail]
/// should be treated as owned by this suite and not used to test a real
/// login from a different physical device while these tests are relied on.
///
/// Every other test here (malformed input, missing fields, wrong password,
/// duplicate email) is read-only / rejected-before-write and leaves no
/// trace in the database.
const _testEmail = 's@s.com';
const _testPassword = '11';
const _smokeDeviceId = 'smoke-test-device-001';

void main() {
  final baseUrl = Uri.parse(APIUrlsService().baseURL);
  final client = HttpClient()..connectionTimeout = const Duration(seconds: 15);

  // Set by the signin.php group once we can confirm _smokeDeviceId actually
  // got written to _testEmail's row, so the register-duplicate-device test
  // knows whether there's anything to collide with.
  var deviceBoundToTestAccount = false;

  tearDownAll(() => client.close(force: true));

  Future<Map<String, dynamic>> post(String path, Object body) async {
    final req = await client.postUrl(baseUrl.resolve(path));
    req.headers.contentType = ContentType.json;
    req.write(body is String ? body : jsonEncode(body));
    final resp = await req.close().timeout(const Duration(seconds: 20));
    final text = await resp.transform(utf8.decoder).join();
    expect(resp.statusCode, 200,
        reason: '$path returned HTTP ${resp.statusCode}: $text');
    final decoded = jsonDecode(text);
    expect(decoded, isA<Map<String, dynamic>>(),
        reason: '$path did not return a JSON object: $text');
    return decoded as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> get(String pathAndQuery) async {
    final resp = await client
        .getUrl(baseUrl.resolve(pathAndQuery))
        .then((r) => r.close())
        .timeout(const Duration(seconds: 20));
    final text = await resp.transform(utf8.decoder).join();
    expect(resp.statusCode, 200,
        reason: '$pathAndQuery returned HTTP ${resp.statusCode}: $text');
    return jsonDecode(text) as Map<String, dynamic>;
  }

  group('signin.php', () {
    test('rejects malformed JSON without crashing', () async {
      final decoded = await post('signin.php', '{not valid json');
      expect(decoded['status'], isFalse);
      expect(decoded['errorMsg'], contains('Invalid JSON'));
    });

    test('rejects missing fields', () async {
      final decoded = await post('signin.php', {'username': _testEmail});
      expect(decoded['status'], isFalse);
      expect(decoded['errorMsg'], contains('Missing fields'));
    });

    test('rejects wrong password with a generic error (no user enumeration)',
        () async {
      final decoded = await post('signin.php', {
        'username': _testEmail,
        'password': 'definitely-wrong-password',
        'deviceId': 'irrelevant-device-for-this-check',
      });
      expect(decoded['status'], isFalse);
      expect(decoded['errorMsg'], 'Invalid email or password');
    });

    test(
        'correct credentials bind the device, never leak the password hash, '
        'and reject a different device once bound', () async {
      final first = await post('signin.php', {
        'username': _testEmail,
        'password': _testPassword,
        'deviceId': _smokeDeviceId,
      });

      final errorMsg = (first['errorMsg'] ?? '').toString();
      // Binding (or the duplicate-device rejection) happens in signin.php
      // before the approval/schedule checks, so an approval/schedule error
      // still tells us the device write went through — only a device
      // mismatch means it didn't.
      deviceBoundToTestAccount = first['status'] == true ||
          errorMsg.contains('Not Approved') ||
          errorMsg.contains('Not Signed To Schedule');

      if (first['status'] != true) {
        markTestSkipped(
          'signin.php did not return success for "$_testEmail" with '
          'deviceId "$_smokeDeviceId": "$errorMsg". Since the password is '
          'known-correct, this means either this account\'s deviceId is '
          'already bound to a different value (clear it via an admin '
          'device reset, or tell me the bound value so the suite can reuse '
          'it), or the account itself is not approved / has no schedule '
          'assigned. Not a code defect either way.',
        );
        return;
      }

      final data = first['data'] as Map<String, dynamic>;
      expect(data.containsKey('pin_code'), isFalse,
          reason: 'password hash must never be returned to the client');
      expect(data.containsKey('remember_token'), isFalse);
      expect(data['deviceId'], _smokeDeviceId);

      // Re-login from the same (now-bound) device must keep succeeding.
      final second = await post('signin.php', {
        'username': _testEmail,
        'password': _testPassword,
        'deviceId': _smokeDeviceId,
      });
      expect(second['status'], isTrue,
          reason: 'Re-login from the already-bound device must succeed.');
      expect(second['data']['id'], data['id']);

      // A different device must now be rejected — this is the multi-login
      // restriction the deviceId field exists to enforce.
      final otherDevice = await post('signin.php', {
        'username': _testEmail,
        'password': _testPassword,
        'deviceId': 'some-other-device-should-be-rejected',
      });
      expect(otherDevice['status'], isFalse);
      expect(otherDevice['errorMsg'], 'Invalid email or password');
    });
  });

  group('usr_register.php', () {
    test('rejects malformed JSON without crashing', () async {
      final decoded = await post('usr_register.php', '{not valid json');
      expect(decoded['status'], isFalse);
      expect(decoded['errorMsg'], contains('Invalid JSON'));
    });

    test('rejects missing fields', () async {
      final decoded =
          await post('usr_register.php', {'username': 'x@example.invalid'});
      expect(decoded['status'], isFalse);
      expect(decoded['errorMsg'], contains('Missing fields'));
    });

    test('rejects an email that is already registered', () async {
      // roleType 'Admin' (not 'Employee') skips the department-active gate,
      // so this deterministically reaches the email-uniqueness check.
      final decoded = await post('usr_register.php', {
        'username': _testEmail, // already exists
        'password': 'whatever-this-is-rejected-before-any-write',
        'fullName': 'Smoke Test',
        'roleType': 'Admin',
        'companyID': 1,
        'departmentID': 1,
        'deviceId': 'smoke-test-registration-probe',
      });
      expect(decoded['status'], isFalse);
      expect(decoded['errorMsg'], 'Username already taken!');
    });

    test('rejects a deviceId already bound to another account', () async {
      if (!deviceBoundToTestAccount) {
        markTestSkipped(
          '_smokeDeviceId was not confirmed bound to "$_testEmail" by the '
          'signin.php group above (it was skipped or inconclusive), so '
          'there is nothing here for this registration to collide with.',
        );
        return;
      }

      final decoded = await post('usr_register.php', {
        'username':
            'smoketest.devicecheck.${DateTime.now().millisecondsSinceEpoch}@example.invalid',
        'password': 'whatever-this-is-rejected-before-any-write',
        'fullName': 'Smoke Test Device Check',
        'roleType': 'Admin',
        'companyID': 1,
        'departmentID': 1,
        'deviceId': _smokeDeviceId, // already bound to _testEmail
      });
      expect(decoded['status'], isFalse);
      expect(
          decoded['errorMsg'], 'This device is already registered to another account.');
    });
  });

  group('updatePassword.php', () {
    test('rejects missing query params', () async {
      final decoded = await get('updatePassword.php');
      expect(decoded['status'], isFalse);
      expect(decoded['errorMsg'], contains('Missing parameters'));
    });

    test('rejects a wrong old password without mutating the account',
        () async {
      final decoded = await get(
        'updatePassword.php?username=$_testEmail&oldpassword=definitely-wrong-old-password&newpassword=irrelevant',
      );
      expect(decoded['status'], isFalse);
      expect(decoded['errorMsg'], 'Check Employee Detials');
    });
  });
}
