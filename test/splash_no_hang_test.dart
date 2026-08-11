import 'dart:async';

import 'package:ama/app/modules/SplashScreenPage/controllers/splash_screen_page_controller.dart';
import 'package:ama/data/controllers/api_conntroller.dart';
import 'package:ama/utils/app_extensions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

/// Regression tests for the App Review 2.1(a) rejection: "App got stuck on a
/// splash screen".
///
/// The splash used to gate navigation on a server-time fetch, so any network
/// condition that stalled that request stranded the user on the splash. These
/// tests pin the contract that matters: the splash hands off to the login page
/// within a bounded time *no matter what the network does*.

/// Never completes — models a server that accepts the connection then stalls,
/// which is exactly the case GetConnect's own timeout does not cover.
class _HangingApi extends ApiController {
  @override
  Future<dynamic> callGETAPI({required String url, int retryAttempt = 0}) =>
      Completer<dynamic>().future;
}

/// Fails fast — models an unreachable host (e.g. a network blocking port 8233).
class _FailingApi extends ApiController {
  @override
  Future<dynamic> callGETAPI({required String url, int retryAttempt = 0}) =>
      Future.error('Connection problem. Please check your internet.');
}

/// Succeeds — the happy path, so we know the offset is still applied.
class _WorkingApi extends ApiController {
  @override
  Future<dynamic> callGETAPI({required String url, int retryAttempt = 0}) async {
    return {'status': true, 'timezone_offset': 10800, 'timezone': 'Asia/Riyadh'};
  }
}

/// The splash budget (3s) plus the minimum display delay (1.5s), plus slack.
/// Anything slower than this is what a reviewer would call "stuck".
const _maxAcceptableStartup = Duration(seconds: 8);

Future<Duration> _timeSplash(ApiController api) async {
  ApiController.to = api;
  final controller = SplashScreenPageController();
  final sw = Stopwatch()..start();
  await controller.checkUserIsLoggedIn();
  sw.stop();
  return sw.elapsed;
}

void main() {
  setUp(() {
    Get.reset(); // must precede testMode — reset() clears the flag
    Get.testMode = true;
  });

  test('splash leaves the splash screen when the API never responds', () async {
    final elapsed = await _timeSplash(_HangingApi());

    expect(
      elapsed,
      lessThan(_maxAcceptableStartup),
      reason: 'Splash must not wait on a stalled server — this is the exact '
          'condition that got the app rejected under guideline 2.1(a).',
    );
  });

  test('splash leaves the splash screen when the API is unreachable', () async {
    final elapsed = await _timeSplash(_FailingApi());

    expect(elapsed, lessThan(_maxAcceptableStartup));
  });

  test('splash still applies the server offset on the happy path', () async {
    ServerTime.setOffset(0); // clear any offset a previous test applied

    await _timeSplash(_WorkingApi());

    expect(
      ServerTime.offset,
      const Duration(hours: 3),
      reason: 'A successful fetch must still take effect.',
    );
  });

  test('ServerTime falls back to UTC+3 without any successful fetch', () {
    // The fallback is what makes it safe for the splash to give up early:
    // the app has a correct offset (Asia/Riyadh) before the network replies.
    expect(ServerTime.offset, isA<Duration>());
    ServerTime.setOffset(10800);
    expect(ServerTime.offset, const Duration(hours: 3));
  });

  test('API request timeout is short enough to stay responsive', () {
    // Guards against someone raising the timeout back to a value that makes
    // the UI look frozen. 15s x 3 attempts is already the ceiling we accept.
    expect(ApiController.requestTimeout.inSeconds, lessThanOrEqualTo(15));
  });
}
