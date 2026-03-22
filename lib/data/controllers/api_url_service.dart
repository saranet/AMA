import 'package:get/get.dart';

class APIUrlsService extends GetxService {
  static APIUrlsService to = Get.isRegistered<APIUrlsService>()
      ? Get.find<APIUrlsService>()
      : Get.put(APIUrlsService());
  // final String baseURL = "http://10.0.2.2:1010/"; //for App localhost
  final String baseURL = "https://ama.deef.com:8232/"; // for web app localhost

  ////////// ?? AUTH          ??/////////////

  final String login = "signin.php";
  final String signup = "usr_register.php";
  String updatePassword(
          String username, String oldpassword, String reenterPassword) =>
      "updatePassword.php?username=$username&oldpassword=$oldpassword&newpassword=$reenterPassword";

  //////////////////?? Home Page API     ??////////////////
  final String add_shedule = "activity/add_schedule.php";
  final String dailyInOut = "activity/dailyInOut.php";
  final String fetchBranches = "activity/fetch_Branches.php";
  String fetchDepts(String BranchID) =>
      "activity/fetch_Dept.php?BranchID=$BranchID";
  String homeAnalyticsData(String userID, String companyID) =>
      "auth/homeAnalyticsData?userID=$userID&companyID=$companyID";
  String allowedZones() {
    return "activity/get_zones.php";
  }

  String getDataByIDAndCompanyIdAndDate(
    String id,
    String compnayID,
    String date,
  ) =>
      "activity/getDataByIDAndCompanyIdAndDate.php?id=$id&compnayID=$compnayID&date=$date";
  String getActivityList(
    String id,
    String compnayID,
    String date,
  ) =>
      "activity/activity/getActivityList?id=$id&compnayID=$compnayID&date=$date";

  //////////////?? HOLIDAY   ??/////////////
  String allHolidayByCompanyID(String compnayID) =>
      "company/getHoliday?companyId=$compnayID";
  String get createHoliday => "company/create";
  String get deleteHoliday => "company/deleteHoliday";

  ///////////?? COMPANY    ??///////////
  String get updateCompany => "company/updateCompany";

  ////////// ?? Leave ??///////////////////
  final String addLeave = "activity/applyLeave.php";

  String get approveRejectLeave => "activity/approveReject.php";

  String getAllLeaves(String userID, String compnayID, String departmentID,
          String roleType, bool myLeave) =>
      "activity/getAllLeaves.php?userID=$userID&companyID=$compnayID&departmentID=$departmentID&roleType=$roleType&myLeave=$myLeave";

/////////////?? Schedule Report ??///////////////
  ///
  String getAllSchedules(String userID, String compnayID, String departmentID,
          String roleType, bool mySchedule) =>
      "activity/getAllSchedules.php?userID=$userID&companyID=$compnayID&departmentID=$departmentID&roleType=$roleType&mySchedule=$mySchedule";

  ////////////////////??     TEAMS              ??/////////////////
  String get addTeam => "team/add";

  String get addMember => "team/add/member";

  String fetchAllAdminManagerByCompany(
          String companyID, String userID, String departmentID) =>
      "activity/fetchAllAdminManagerByCompany.php?companyID=$companyID&userId=$userID&departmentID=$departmentID";

  String fetchTeams(String companyID, String departmentID, String userID,
          String roleType) =>
      "activity/fetch_teams.php?companyID=$companyID&departmentID=$departmentID&userId=$userID&roleType=$roleType";

  String fetchMembers(String userID, String companyID, String teamID) =>
      "activity/fetchMembers.php?userID=$userID&companyID=$companyID&teamID=$teamID";
}
