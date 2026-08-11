@Tags(['network'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:ama/data/controllers/api_url_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pre-submission gate for the configured API endpoint.
///
/// The 2.1(a) rejection had two halves. The app-side hang is fixed and covered
/// by splash_no_hang_test.dart. This file covers the other half: the reviewer's
/// device has to actually be able to *reach* the API. Run it before every
/// submission — it hits the real endpoint the shipped build will use.
///
///   flutter test test/api_reachability_test.dart
///
/// Note this passes trivially from your own network. What it really guards is
/// the port: App Review runs behind infrastructure that commonly blocks
/// non-standard outbound ports, which is the leading explanation for the
/// reviewer seeing a frozen splash while the app worked fine locally.
void main() {
  final baseUrl = Uri.parse(APIUrlsService().baseURL);

  test('API base URL uses HTTPS', () {
    expect(baseUrl.scheme, 'https',
        reason: 'iOS App Transport Security requires HTTPS.');
  });

  test('API base URL uses the standard HTTPS port (443)', () {
    expect(
      baseUrl.hasPort && baseUrl.port != 443,
      isFalse,
      reason: 'baseURL points at port ${baseUrl.port}. Non-standard ports are '
          'routinely blocked by corporate and review networks, so the app may '
          'be unreachable during App Review even though it works for you. '
          'Serve the API on 443 and update APIUrlsService.baseURL.',
    );
  });

  test('server_time endpoint answers with valid JSON', () async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 15);
    addTearDown(() => client.close(force: true));

    final target = baseUrl.resolve('server_time.php');
    final response = await client
        .getUrl(target)
        .then((r) => r.close())
        .timeout(const Duration(seconds: 20));

    expect(response.statusCode, 200, reason: 'Unreachable endpoint: $target');

    final body = await response.transform(utf8.decoder).join();
    final decoded = jsonDecode(body);

    expect(decoded, isA<Map<String, dynamic>>());
    expect(decoded['timezone_offset'], isA<num>(),
        reason: 'The splash reads timezone_offset from this response.');
  });

  test('API certificate is trusted without any ATS exception', () async {
    // A self-signed or expired cert would be rejected outright by iOS, which
    // presents to a reviewer as an app that simply never loads.
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 15);
    client.badCertificateCallback = (_, __, ___) => false;
    addTearDown(() => client.close(force: true));

    final response = await client
        .getUrl(baseUrl.resolve('server_time.php'))
        .then((r) => r.close())
        .timeout(const Duration(seconds: 20));
    await response.drain<void>();

    expect(response.certificate, isNotNull);
    expect(
      response.certificate!.endValidity.isAfter(DateTime.now()),
      isTrue,
      reason: 'TLS certificate has expired.',
    );
  });
}
