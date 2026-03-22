import 'package:get/get.dart';

import '../modules/ApplyLeavePage/bindings/apply_leave_page_binding.dart';
import '../modules/ApplyLeavePage/views/apply_leave_page_view.dart';
import '../modules/AttendReport/bindings/attend_report_binding.dart';
import '../modules/AttendReport/views/attend_report_view.dart';
import '../modules/Auth/bindings/auth_binding.dart';
import '../modules/Auth/bindings/auth_binding.dart';
import '../modules/Auth/views/auth_view.dart';
import '../modules/Auth/views/auth_view.dart';
import '../modules/DashBoardPage/bindings/dash_board_page_binding.dart';
import '../modules/DashBoardPage/views/dash_board_page_view.dart';
import '../modules/LeavePage/bindings/leave_page_binding.dart';
import '../modules/LeavePage/views/leave_page_view.dart';
import '../modules/LoginPage/bindings/login_page_binding.dart';
import '../modules/LoginPage/views/login_page_view.dart';
import '../modules/ScheduleReport/bindings/schedule_report_binding.dart';
import '../modules/ScheduleReport/views/schedule_report_view.dart';
import '../modules/SchedulesPage/bindings/schedules_page_binding.dart';
import '../modules/SchedulesPage/views/schedules_page_view.dart';
import '../modules/SignUpPage/bindings/sign_up_page_binding.dart';
import '../modules/SignUpPage/views/sign_up_page_view.dart';
import '../modules/SplashScreenPage/bindings/splash_screen_page_binding.dart';
import '../modules/SplashScreenPage/views/splash_screen_page_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN_PAGE;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH_SCREEN_PAGE,
      page: () => const SplashScreenPageView(),
      binding: SplashScreenPageBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_UP_PAGE,
      page: () => const SignUpPageView(),
      binding: SignUpPageBinding(),
    ),
    GetPage(
      name: _Paths.DASH_BOARD_PAGE,
      page: () => const DashBoardPageView(),
      binding: DashBoardPageBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_PAGE,
      page: () => const LoginPageView(),
      binding: LoginPageBinding(),
    ),
    GetPage(
      name: _Paths.LEAVE_PAGE,
      page: () => const LeavePageView(),
      binding: LeavePageBinding(),
    ),
    GetPage(
      name: _Paths.APPLY_LEAVE_PAGE,
      page: () => ApplyLeavePageView(),
      binding: ApplyLeavePageBinding(),
    ),
    GetPage(
      name: _Paths.SCHEDULES_PAGE,
      page: () => const SchedulesPageView(),
      binding: SchedulesPageBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.ATTEND_REPORT,
      page: () => const AttendReportView(),
      binding: AttendReportBinding(),
    ),
    GetPage(
      name: _Paths.SCHEDULE_REPORT,
      page: () => const ScheduleReportView(),
      binding: ScheduleReportBinding(),
    ),
  ];
}
