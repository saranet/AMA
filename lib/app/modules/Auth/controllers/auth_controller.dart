import 'dart:io';

import 'package:ama/app/modules/LoginPage/controllers/login_page_controller.dart';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:uuid/uuid.dart';

class AuthController extends GetxController {
  final LocalAuthentication auth = LocalAuthentication();
  final isBiometricAvailable = false.obs;

  var isAuthenticated = false.obs;

  final _storage = const FlutterSecureStorage();
  var isLoggedIn = false.obs;

  static const _deviceIdStorageKey = 'stable_device_id';

  String? _cachedDeviceId;

  @override
  void onInit() {
    super.onInit();
    checkBiometricSupport();
    _prefetchDeviceId();
  }

  Future<void> _prefetchDeviceId() async {
    _cachedDeviceId = await _fetchDeviceId();
  }

  Future<String> getDeviceId() async {
    return _cachedDeviceId ?? await _fetchDeviceId();
  }

  Future<String> _fetchDeviceId() async {
    // Reuse the persisted value so the id stays identical across app
    // restarts and (on iOS, where Keychain data survives uninstall) across
    // reinstalls of the app on the same physical device.
    final stored = await _storage.read(key: _deviceIdStorageKey);
    if (stored != null && stored.isNotEmpty) {
      return stored;
    }

    String? resolvedId;
    try {
      if (Platform.isAndroid) {
        // Settings.Secure.ANDROID_ID: unique per device + app signing key
        // + user, stable across reinstalls, and reset by the OS on a
        // factory reset. `device_info_plus`'s `androidInfo.id` is
        // `Build.ID` (the OS build fingerprint), which is identical on
        // every device running the same firmware image -- that mismatch
        // is why unrelated devices were ending up with the same id.
        resolvedId = await const AndroidId().getId();
      } else if (Platform.isIOS) {
        final iosInfo = await DeviceInfoPlugin().iosInfo;
        resolvedId = iosInfo.identifierForVendor;
      }
    } catch (_) {
      resolvedId = null;
    }

    // No shared placeholder strings: if the OS id is unavailable, generate
    // a random id instead of a hardcoded fallback, so devices that hit
    // this path never collide with each other.
    final deviceId =
        (resolvedId == null || resolvedId.isEmpty) ? const Uuid().v4() : resolvedId;

    await _storage.write(key: _deviceIdStorageKey, value: deviceId);
    return deviceId;
  }

  Future<void> checkBiometricSupport() async {
    try {
      final canCheck = await auth.canCheckBiometrics;
      final isSupported = await auth.isDeviceSupported();
      isBiometricAvailable.value = canCheck && isSupported;
    } catch (e) {
      isBiometricAvailable.value = false;
    }
  }

  /// Check if saved credentials exist
  Future<bool> hasSavedCredentials() async {
    final loginController = Get.find<LoginPageController>();
    final username = await _storage.read(key: 'username');
    final password = await _storage.read(key: 'password');
    loginController.usernameTC.text = username ?? "";
    return username != null && password != null;
  }

  /// Fingerprint / Biometric login
  Future<void> loginWithBiometrics() async {
    try {
      final canCheck = await auth.canCheckBiometrics;
      final isDeviceSupported = await auth.isDeviceSupported();

      if (!canCheck || !isDeviceSupported) {
        Get.snackbar("Biometrics", "Device does not support biometrics ❌");
        return;
      }

      final didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate with your fingerprint',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (!didAuthenticate) {
        Get.snackbar("Biometrics", "Authentication failed ❌");
        return;
      }
      final username = await _storage.read(key: 'username');
      final password = await _storage.read(key: 'password');

      if (username == null || password == null) {
        Get.snackbar("Error", "No saved credentials. Please login manually.");
        return;
      }
      //  loginController.usernameTC.text = username;
      // loginController.passTC.text = password;
      final loginController = Get.find<LoginPageController>();
      await loginController.login(
        username: username,
        password: password,
      ); // uses updated login() with deviceId
    } catch (e) {
      await _storage.deleteAll();
      Get.snackbar("Biometrics", "Error: $e");
    }
  }

  Future<void> authenticateAndRun(Function action) async {
    try {
      final didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate with your fingerprint',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        action(); // run the passed function
      } else {
        Get.snackbar("Authentication", "Fingerprint verification failed ❌");
      }
    } catch (e) {
      Get.snackbar("Authentication", "Error: $e");
    }
  }
}
