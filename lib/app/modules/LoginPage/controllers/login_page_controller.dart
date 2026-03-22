import 'dart:convert';

import 'package:ama/app/modules/Auth/controllers/auth_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:ama/app/routes/app_pages.dart';
import 'package:ama/data/controllers/api_conntroller.dart';
import 'package:ama/data/controllers/api_url_service.dart';
import 'package:ama/data/controllers/app_storage_service.dart';
import 'package:ama/utils/app_extensions.dart';
import 'package:ama/utils/app_images.dart';
import 'package:ama/utils/helper_function.dart';
import 'package:ama/widgets/app_textfield.dart';
import 'package:local_auth/local_auth.dart';

class LoginPageController extends GetxController {
  String get appImageLogo => AppImages.appLogo;
  var usernameTC = TextEditingController(), passTC = TextEditingController();
  // Biometric
  final LocalAuthentication auth = LocalAuthentication();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  var isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  void gotoSignUpPage() {
    Get.offAllNamed(Routes.SIGN_UP_PAGE);
  }

  // ----------------- Existing Login Method -----------------
  login({String? username, String? password}) async {
    if (!isLoading.value) {
      isLoading.value = true;
      final user = username ?? usernameTC.text.trim();
      final pass = password ?? passTC.text.trim();

      // get deviceId for multi-login restriction
      final deviceId = await Get.find<AuthController>().getDeviceId();
      print("Device ID: $deviceId");
      print("*************************Login Password: $pass");
      ApiController.to.callPOSTAPI(
        url: APIUrlsService.to.login,
        body: {
          "username": user,
          "password": pass,
          "deviceId": deviceId,
        },
      ).then((resp) async {
        isLoading.value = false;
        // if (resp is Map<String, dynamic>) {
        // resp = jsonDecode(resp);
        if (resp['status'] == true) {
          if (resp['message'].toString() == "Please set new password.") {
            showResetPasswordDialog();
          } else {
            await AppStorageController.to
                .login(resp['data'] as Map<String, dynamic>);

            // Save credentials for biometric login
            if (username == null && password == null) {
              await secureStorage.write(key: 'username', value: user);
              await secureStorage.write(key: 'password', value: pass);
            }
            showSuccessSnack("User Logged.");
          }
        } else {
          showErrorSnack(resp['errorMsg']?.toString() ?? "Unknown error.");
        }
        /* } else {
          isLoading.value = false;
          showErrorSnack("Invalid API response format.");
        }*/
      }).catchError((e) {
        isLoading.value = false;
        if (e is Map<String, dynamic> &&
            e['message'].toString() == "Please set new password.") {
          showResetPasswordDialog();
        } else {
          showErrorSnack((e is Map && e.containsKey('errorMsg'))
              ? e['errorMsg'].toString()
              : e.toString());
        }
      });
    }
  }

  void showResetPasswordDialog() {
    isLoading.value = false;
    String password = "", renterPassword = "";
    Get.defaultDialog(
      title: "Set New Password",
      barrierDismissible: false,
      content: Column(
        children: [
          24.height,
          AppTextField(
            hintText: "Enter new password",
            onChanged: (p) => password = p,
          ),
          24.height,
          AppTextField(
            hintText: "Re-Enter new password",
            onChanged: (p) => renterPassword = p,
          ),
          24.height,
        ],
      ),
      textCancel: "Cancel",
      onCancel: closeDialogs,
      textConfirm: "Update Password",
      onConfirm: () async {
        if (renterPassword.trim().isEmpty || password != renterPassword) {
          showErrorSnack("Please enter corrent passowrd");
          return;
        }
        final resp = await ApiController.to.callGETAPI(
          url: APIUrlsService.to
              .updatePassword(usernameTC.text, passTC.text, renterPassword),
        );
        //print("*****************Update Password Response: $resp");
        if (resp['status'] == true) {
          // print("*****************Update : $resp['status'] ");
          passTC.text = renterPassword;
          Get.back();
          showSuccessSnack(
              "Password updated successfully. Please login again.");
        }
      },
    );
  }

  @override
  void onClose() {
    usernameTC.dispose();
    passTC.dispose();
    super.onClose();
  }
}
