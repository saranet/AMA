import 'package:ama/utils/theme/app_fonts.dart';
import 'package:ama/widgets/GradientButton.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ama/app/modules/Auth/controllers/auth_controller.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ama/utils/app_extensions.dart';
import 'package:ama/utils/app_string.dart';
import 'package:ama/utils/theme/app_colors.dart';
import 'package:ama/widgets/app_button.dart';
import 'package:ama/widgets/app_textfield.dart';

import '../../../../l10n/app_localizations.dart';
import '../controllers/login_page_controller.dart';

class LoginPageView extends GetView<LoginPageController> {
  const LoginPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      // ✅ Language switcher in AppBar — always visible, always tappable
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.language,
              size: 30,
              color: Colors.black87,
            ),
            tooltip: l10n.changeLanguage,
            onSelected: (String lang) {
              print('🌐 Language selected: $lang');
              GetStorage().write('lang', lang);
              Get.updateLocale(Locale(lang));
              print('🌐 Locale after update: ${Get.locale}');
              Get.forceAppUpdate();
            },
            itemBuilder: (BuildContext context) => const [
              PopupMenuItem<String>(
                value: 'en',
                child: Row(
                  children: [
                    Text('🇬🇧', style: TextStyle(fontSize: 22)),
                    SizedBox(width: 12),
                    Text('English'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'ar',
                child: Row(
                  children: [
                    Text('🇸🇦', style: TextStyle(fontSize: 22)),
                    SizedBox(width: 12),
                    Text('العربية'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
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
              l10n.helloThereLoginToContinue,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: AppColors.kGrey300,
              ),
            ),
            16.height,
            AppTextField(
              hintText: l10n.username,
              controller: controller.usernameTC,
            ),
            16.height,
            AppTextField(
              hintText: l10n.password,
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
                    label: l10n.logIn,
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
                              l10n.orLoginWithFingerprint,
                              style: Get.textTheme.bodySmall,
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.fingerprint,
                                size: 50,
                                color: AppColors.kBlue900,
                              ),
                              tooltip: l10n.loginWithFingerprint,
                              onPressed: available
                                  ? () => authController.loginWithBiometrics()
                                  : null,
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
                      text: l10n.dontHaveAnAccount,
                      style: Get.textTheme.bodySmall,
                    ),
                    TextSpan(
                      text: " ${l10n.signUp}",
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
