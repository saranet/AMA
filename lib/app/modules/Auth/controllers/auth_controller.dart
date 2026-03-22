import 'dart:io';

import 'package:ama/app/modules/LoginPage/controllers/login_page_controller.dart';
import 'package:ama/app/routes/app_pages.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class AuthController extends GetxController {
  final LocalAuthentication auth = LocalAuthentication();
  final isBiometricAvailable = false.obs;

  var isAuthenticated = false.obs;

  final _storage = const FlutterSecureStorage();
  var isLoggedIn = false.obs;

  Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // unique Android ID
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? "unknown_ios";
    }
    return "unknown_device";
  }

  @override
  void onInit() {
    super.onInit();
    checkBiometricSupport();
    //  hasSavedCredentials();
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
      print("Biometric login for user: $username -- $password ");

      //  loginController.usernameTC.text = username;
      // loginController.passTC.text = password;
      final loginController = Get.find<LoginPageController>();
      await loginController.login(
        username: username,
        password: password,
      ); // uses updated login() with deviceId
    } catch (e) {
      print("Error: $e");
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
