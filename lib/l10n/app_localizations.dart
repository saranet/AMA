import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @userLogged.
  ///
  /// In en, this message translates to:
  /// **'User logged in'**
  String get userLogged;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAnAccount;

  /// No description provided for @doyouHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Do you have an account?'**
  String get doyouHaveAnAccount;

  /// No description provided for @helloThereLoginToContinue.
  ///
  /// In en, this message translates to:
  /// **'Hello there, login to continue'**
  String get helloThereLoginToContinue;

  /// No description provided for @helloThereSignUpToContinue.
  ///
  /// In en, this message translates to:
  /// **'Hello there, sign up to continue'**
  String get helloThereSignUpToContinue;

  /// No description provided for @registerAccount.
  ///
  /// In en, this message translates to:
  /// **'Register account'**
  String get registerAccount;

  /// No description provided for @employeeSignUp.
  ///
  /// In en, this message translates to:
  /// **'Employee Sign Up'**
  String get employeeSignUp;

  /// No description provided for @adminSignUp.
  ///
  /// In en, this message translates to:
  /// **'Admin Sign Up'**
  String get adminSignUp;

  /// No description provided for @loginWithFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Login with fingerprint'**
  String get loginWithFingerprint;

  /// No description provided for @orLoginWithFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Or login with fingerprint'**
  String get orLoginWithFingerprint;

  /// No description provided for @youCanLoginLaterWithFingerprint.
  ///
  /// In en, this message translates to:
  /// **'You can login later with fingerprint'**
  String get youCanLoginLaterWithFingerprint;

  /// No description provided for @setNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Set new password'**
  String get setNewPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get enterNewPassword;

  /// No description provided for @enterNewPassword_1.
  ///
  /// In en, this message translates to:
  /// **'Enter new password again'**
  String get enterNewPassword_1;

  /// No description provided for @enterOldPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter old password'**
  String get enterOldPassword;

  /// No description provided for @reenterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter new password'**
  String get reenterNewPassword;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get updatePassword;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get passwordUpdated;

  /// No description provided for @passwordUpdatedSuccessfullyPleaseLoginAgain.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully. Please login again'**
  String get passwordUpdatedSuccessfullyPleaseLoginAgain;

  /// No description provided for @pleaseEnterCorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter correct password'**
  String get pleaseEnterCorrectPassword;

  /// No description provided for @pleaseEnterOldPasswordAndNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter old and new password'**
  String get pleaseEnterOldPasswordAndNewPassword;

  /// No description provided for @userDetails.
  ///
  /// In en, this message translates to:
  /// **'User details'**
  String get userDetails;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'User name'**
  String get userName;

  /// No description provided for @branchDetails.
  ///
  /// In en, this message translates to:
  /// **'Branch details'**
  String get branchDetails;

  /// No description provided for @branchName.
  ///
  /// In en, this message translates to:
  /// **'Branch name'**
  String get branchName;

  /// No description provided for @departmentDetails.
  ///
  /// In en, this message translates to:
  /// **'Department details'**
  String get departmentDetails;

  /// No description provided for @departmentName.
  ///
  /// In en, this message translates to:
  /// **'Department name'**
  String get departmentName;

  /// No description provided for @organizationDetails.
  ///
  /// In en, this message translates to:
  /// **'Organization details'**
  String get organizationDetails;

  /// No description provided for @organizationName.
  ///
  /// In en, this message translates to:
  /// **'Organization name'**
  String get organizationName;

  /// No description provided for @updateOrganization.
  ///
  /// In en, this message translates to:
  /// **'Update organization'**
  String get updateOrganization;

  /// No description provided for @hrAttendance.
  ///
  /// In en, this message translates to:
  /// **'HR Attendance'**
  String get hrAttendance;

  /// No description provided for @todayAttendence.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Attendance'**
  String get todayAttendence;

  /// No description provided for @attendanceReport.
  ///
  /// In en, this message translates to:
  /// **'Attendance report'**
  String get attendanceReport;

  /// No description provided for @attendanceBlocked.
  ///
  /// In en, this message translates to:
  /// **'Attendance blocked'**
  String get attendanceBlocked;

  /// No description provided for @attendanceRecorded.
  ///
  /// In en, this message translates to:
  /// **'Attendance recorded'**
  String get attendanceRecorded;

  /// No description provided for @youAreOutsideAllowedAttendanceZone.
  ///
  /// In en, this message translates to:
  /// **'You are outside allowed attendance zone'**
  String get youAreOutsideAllowedAttendanceZone;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check In'**
  String get checkIn;

  /// No description provided for @checkOut.
  ///
  /// In en, this message translates to:
  /// **'Check Out'**
  String get checkOut;

  /// No description provided for @breakTime.
  ///
  /// In en, this message translates to:
  /// **'Break Time'**
  String get breakTime;

  /// No description provided for @totalDays.
  ///
  /// In en, this message translates to:
  /// **'Total Days'**
  String get totalDays;

  /// No description provided for @totalWorkingHours.
  ///
  /// In en, this message translates to:
  /// **'Total Working Hours'**
  String get totalWorkingHours;

  /// No description provided for @workingDays.
  ///
  /// In en, this message translates to:
  /// **'Working days'**
  String get workingDays;

  /// No description provided for @swipeToCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Swipe to Check in'**
  String get swipeToCheckIn;

  /// No description provided for @swipeToCheckOut.
  ///
  /// In en, this message translates to:
  /// **'Swipe to Check out'**
  String get swipeToCheckOut;

  /// No description provided for @swipeToBreakIn.
  ///
  /// In en, this message translates to:
  /// **'Swipe to Break in'**
  String get swipeToBreakIn;

  /// No description provided for @swipeToBreakOut.
  ///
  /// In en, this message translates to:
  /// **'Swipe to Break out'**
  String get swipeToBreakOut;

  /// No description provided for @yourActivity.
  ///
  /// In en, this message translates to:
  /// **'Your activity'**
  String get yourActivity;

  /// No description provided for @userActivity.
  ///
  /// In en, this message translates to:
  /// **'User activity'**
  String get userActivity;

  /// No description provided for @allLeaves.
  ///
  /// In en, this message translates to:
  /// **'All leaves'**
  String get allLeaves;

  /// No description provided for @applyLeave.
  ///
  /// In en, this message translates to:
  /// **'Apply leave'**
  String get applyLeave;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @casualSick.
  ///
  /// In en, this message translates to:
  /// **'Casual/Sick'**
  String get casualSick;

  /// No description provided for @wfh.
  ///
  /// In en, this message translates to:
  /// **'WFH'**
  String get wfh;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @reasonForLeave.
  ///
  /// In en, this message translates to:
  /// **'Reason for leave'**
  String get reasonForLeave;

  /// No description provided for @selectLeaveType.
  ///
  /// In en, this message translates to:
  /// **'Select leave type'**
  String get selectLeaveType;

  /// No description provided for @selectApprovalPerson.
  ///
  /// In en, this message translates to:
  /// **'Select approval person'**
  String get selectApprovalPerson;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @enterRejectReason.
  ///
  /// In en, this message translates to:
  /// **'Enter reject reason'**
  String get enterRejectReason;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @allSchedules.
  ///
  /// In en, this message translates to:
  /// **'All schedules'**
  String get allSchedules;

  /// No description provided for @mySchedule.
  ///
  /// In en, this message translates to:
  /// **'My schedule'**
  String get mySchedule;

  /// No description provided for @otherSchedules.
  ///
  /// In en, this message translates to:
  /// **'Other schedules'**
  String get otherSchedules;

  /// No description provided for @addSchedule.
  ///
  /// In en, this message translates to:
  /// **'Add schedule'**
  String get addSchedule;

  /// No description provided for @scheduleName.
  ///
  /// In en, this message translates to:
  /// **'Schedule name'**
  String get scheduleName;

  /// No description provided for @noSchedulesFound.
  ///
  /// In en, this message translates to:
  /// **'No schedules found'**
  String get noSchedulesFound;

  /// No description provided for @holidays.
  ///
  /// In en, this message translates to:
  /// **'Holidays'**
  String get holidays;

  /// No description provided for @noHollidayFound.
  ///
  /// In en, this message translates to:
  /// **'No holidays found'**
  String get noHollidayFound;

  /// No description provided for @addTeam.
  ///
  /// In en, this message translates to:
  /// **'Add team'**
  String get addTeam;

  /// No description provided for @teamName.
  ///
  /// In en, this message translates to:
  /// **'Team name'**
  String get teamName;

  /// No description provided for @addMember.
  ///
  /// In en, this message translates to:
  /// **'Add member'**
  String get addMember;

  /// No description provided for @assignedUsers.
  ///
  /// In en, this message translates to:
  /// **'Assigned users'**
  String get assignedUsers;

  /// No description provided for @departmentEmployeesList.
  ///
  /// In en, this message translates to:
  /// **'Department employees list'**
  String get departmentEmployeesList;

  /// No description provided for @noTeamsFound.
  ///
  /// In en, this message translates to:
  /// **'No teams found'**
  String get noTeamsFound;

  /// No description provided for @noAdminMembersFound.
  ///
  /// In en, this message translates to:
  /// **'No admin members found'**
  String get noAdminMembersFound;

  /// No description provided for @noBranchFound.
  ///
  /// In en, this message translates to:
  /// **'No branch found'**
  String get noBranchFound;

  /// No description provided for @noDepartmentFound.
  ///
  /// In en, this message translates to:
  /// **'No department found'**
  String get noDepartmentFound;

  /// No description provided for @selectBranch.
  ///
  /// In en, this message translates to:
  /// **'Select branch'**
  String get selectBranch;

  /// No description provided for @selectDepartment.
  ///
  /// In en, this message translates to:
  /// **'Select department'**
  String get selectDepartment;

  /// No description provided for @selectStartTime.
  ///
  /// In en, this message translates to:
  /// **'Select start time'**
  String get selectStartTime;

  /// No description provided for @selectEndTime.
  ///
  /// In en, this message translates to:
  /// **'Select end time'**
  String get selectEndTime;

  /// No description provided for @selectStartDate.
  ///
  /// In en, this message translates to:
  /// **'Select start Date'**
  String get selectStartDate;

  /// No description provided for @selectEndDate.
  ///
  /// In en, this message translates to:
  /// **'Select end Date'**
  String get selectEndDate;

  /// No description provided for @perMonthPaidLeave.
  ///
  /// In en, this message translates to:
  /// **'Per month paid leave'**
  String get perMonthPaidLeave;

  /// No description provided for @perMonthSickcasualLeave.
  ///
  /// In en, this message translates to:
  /// **'Per month sick/casual leave'**
  String get perMonthSickcasualLeave;

  /// No description provided for @perMonthWorkFromHome.
  ///
  /// In en, this message translates to:
  /// **'Per month work from home'**
  String get perMonthWorkFromHome;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @label.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get label;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @my.
  ///
  /// In en, this message translates to:
  /// **'My'**
  String get my;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @areYouSureYouWantToDeleteThis.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this?'**
  String get areYouSureYouWantToDeleteThis;

  /// No description provided for @superAdminCanOnlyAddThis.
  ///
  /// In en, this message translates to:
  /// **'Super admin can only add this'**
  String get superAdminCanOnlyAddThis;

  /// No description provided for @superAdminCanOnlyDeleteThis.
  ///
  /// In en, this message translates to:
  /// **'Super admin can only delete this'**
  String get superAdminCanOnlyDeleteThis;

  /// No description provided for @noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get noDataFound;

  /// No description provided for @thisFieldCantBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'This field can\'t be empty'**
  String get thisFieldCantBeEmpty;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// No description provided for @serverResponseError.
  ///
  /// In en, this message translates to:
  /// **'Server response error'**
  String get serverResponseError;

  /// No description provided for @networkApiErrorWhenSendingAttendance.
  ///
  /// In en, this message translates to:
  /// **'Network error when sending attendance'**
  String get networkApiErrorWhenSendingAttendance;

  /// No description provided for @locationServicesAreDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled'**
  String get locationServicesAreDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission permanently denied'**
  String get locationPermissionPermanentlyDenied;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguage;

  /// No description provided for @authview.
  ///
  /// In en, this message translates to:
  /// **'Auth View'**
  String get authview;

  /// No description provided for @authviewIsWorking.
  ///
  /// In en, this message translates to:
  /// **'Auth view is working'**
  String get authviewIsWorking;

  /// No description provided for @breakIn.
  ///
  /// In en, this message translates to:
  /// **'break In'**
  String get breakIn;

  /// No description provided for @breakOut.
  ///
  /// In en, this message translates to:
  /// **'break Out'**
  String get breakOut;

  /// No description provided for @msgLate.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get msgLate;

  /// No description provided for @msgOnTime.
  ///
  /// In en, this message translates to:
  /// **'On Time'**
  String get msgOnTime;

  /// No description provided for @msgOverTime.
  ///
  /// In en, this message translates to:
  /// **'Over Time'**
  String get msgOverTime;

  /// No description provided for @msgEarly.
  ///
  /// In en, this message translates to:
  /// **'Early'**
  String get msgEarly;

  /// No description provided for @msgEarlyCheckout.
  ///
  /// In en, this message translates to:
  /// **'Early Checkout'**
  String get msgEarlyCheckout;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'submit'**
  String get submit;

  /// No description provided for @selectApprovalPersonAndReasonAndType.
  ///
  /// In en, this message translates to:
  /// **'Select approval person, enter leave reason and select leave type'**
  String get selectApprovalPersonAndReasonAndType;

  /// No description provided for @invalidResponseFromServer.
  ///
  /// In en, this message translates to:
  /// **'Invalid response from server'**
  String get invalidResponseFromServer;

  /// No description provided for @noWorkingDaysConfigured.
  ///
  /// In en, this message translates to:
  /// **'No working days configured'**
  String get noWorkingDaysConfigured;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
