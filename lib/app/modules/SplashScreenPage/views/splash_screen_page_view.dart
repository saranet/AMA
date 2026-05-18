import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/splash_screen_page_controller.dart';

class SplashScreenPageView extends StatefulWidget {
  const SplashScreenPageView({super.key});

  @override
  State<SplashScreenPageView> createState() => _SplashScreenPageViewState();
}

class _SplashScreenPageViewState extends State<SplashScreenPageView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.7, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SplashScreenPageController>();

    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value,
              child: child,
            );
          },
          child: Image.asset(
            controller.appImageLogo,
            width: 100,
          ),
        ),
      ),
    );
  }
}
