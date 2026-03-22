import 'package:ama/data/controllers/app_storage_service.dart';
import 'package:ama/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:ama/data/models/user_data_model.dart';
import 'package:get/get.dart';

import '../controllers/dash_board_page_controller.dart';

class DashBoardPageView extends GetView<DashboardPageController> {
  const DashBoardPageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return IndexedStack(
          index: controller.currentIndex.value,
          children: controller.pages,
        );
      }),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: controller.onFloatTap,
        backgroundColor: AppColors.kBlue600,
        child: Icon(
          Icons.people_alt_outlined,
          // ignore: deprecated_member_use
          color: AppColors.kBlack900.withOpacity(.8),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(() {
        return AnimatedBottomNavigationBar(
          icons: const [
            Icons.home_filled,
            Icons.calendar_month_rounded,
            Icons.card_travel_rounded,
            Icons.person_3_outlined,
          ],
          notchMargin: 7,
          activeIndex: controller.currentIndex.value,
          splashRadius: 2,
          inactiveColor: AppColors.kBlack900.withOpacity(.8),
          leftCornerRadius: 35,
          rightCornerRadius: 35,
          activeColor: AppColors.kBlue900,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.defaultEdge,
          backgroundColor: AppColors.kpurpleBackground,
          onTap: controller.onBottomNavTap,
        );
      }),
    );
  }
}
