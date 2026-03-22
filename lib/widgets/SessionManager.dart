import 'dart:async';
import 'package:ama/app/modules/LoginPage/bindings/login_page_binding.dart';
import 'package:ama/app/modules/LoginPage/views/login_page_view.dart';
import 'package:ama/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SessionManager extends StatefulWidget {
  final Widget child;
  final int timeoutMinutes;

  const SessionManager({
    Key? key,
    required this.child,
    this.timeoutMinutes = 5,
  }) : super(key: key);

  @override
  State<SessionManager> createState() => _SessionManagerState();
}

class _SessionManagerState extends State<SessionManager> {
  Timer? _inactivityTimer;

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  void _resetTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(
      Duration(minutes: widget.timeoutMinutes),
      _logoutUser,
    );
  }

  void _logoutUser() {
    _inactivityTimer?.cancel();
    Get.offAllNamed(Routes.LOGIN_PAGE); // Navigate to login page
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _resetTimer(),
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }
}
