import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../l10n/app_localizations.dart';
import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.authview),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          AppLocalizations.of(context)!.authviewIsWorking,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
