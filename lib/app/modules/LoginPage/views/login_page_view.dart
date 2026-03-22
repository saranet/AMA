import 'package:ama/utils/theme/app_fonts.dart';
import 'package:ama/widgets/GradientButton.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ama/app/modules/Auth/controllers/auth_controller.dart';

import 'package:get/get.dart';
import 'package:ama/utils/app_extensions.dart';
import 'package:ama/utils/app_string.dart';
import 'package:ama/utils/theme/app_colors.dart';
import 'package:ama/widgets/app_button.dart';
import 'package:ama/widgets/app_textfield.dart';

import '../controllers/login_page_controller.dart';

class LoginPageView extends GetView<LoginPageController> {
  const LoginPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            24.height,
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                controller.appImageLogo,
                height: 100,
              ),
            ),
            40.height,
            Text(
              "Hello there, login to continue",
              style: Get.textTheme.bodyMedium?.copyWith(
                color: AppColors.kGrey300,
              ),
            ),
            16.height,
            AppTextField(
              hintText: "Username",
              controller: controller.usernameTC,
            ),
            16.height,
            AppTextField(
              hintText: "Password",
              isPassword: true,
              controller: controller.passTC,
            ),
            34.height,
            Obx(() {
              final authController = Get.find<AuthController>();
              final available = authController.isBiometricAvailable.value;

              return Column(
                children: [
                  GradientButton(
                    onPressed: controller.login,
                    label: "Log in",
                    isLoading: controller.isLoading.value,
                  ),
                  20.height,
                  // Fingerprint login button
                  FutureBuilder(
                    future: controller.secureStorage.read(key: 'username'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.data != null) {
                        return Column(
                          children: [
                            Text(
                              "Or login with fingerprint",
                              style: Get.textTheme.bodySmall,
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.fingerprint,
                                size: 50,
                                color: AppColors.kBlue900,
                              ),
                              tooltip: "Login with Fingerprint",
                              onPressed: available
                                  ? () => authController.loginWithBiometrics()
                                  : null, // disables button
                              color: available ? Colors.blue : Colors.grey,
                            ),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ],
              );
            }),
            20.height,
            Align(
              alignment: Alignment.topCenter,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Don't have an account? ",
                      style: Get.textTheme.bodySmall,
                    ),
                    TextSpan(
                      text: " Sign Up",
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: AppColors.kBlue900,
                        fontWeight: AppFontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = controller.gotoSignUpPage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
