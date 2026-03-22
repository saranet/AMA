import 'package:ama/app/models/Branches.dart';
import 'package:ama/app/models/Departments.dart';
import 'package:ama/app/modules/Auth/controllers/auth_controller.dart';
import 'package:ama/app/modules/SignUpPage/model/working_days_model.dart';
import 'package:ama/app/routes/app_pages.dart';
import 'package:ama/data/app_enums.dart';
import 'package:ama/data/controllers/api_url_service.dart';
import 'package:ama/utils/helper_function.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../data/controllers/api_conntroller.dart';
import '../../../../data/controllers/app_storage_service.dart';

class SignUpPageController extends GetxController {
  //TODO: Implement SignUpPageController
  late String role;
  final count = 0.obs;
  var branches = <Branch>[].obs; // list of branches
  var selectedItem = Rxn<Branch>(); // selected value
  var departments = <Departments>[].obs; // list of departments
  var selectedDepartment = Rxn<Departments>(); // selected department
  var emailTc = TextEditingController(),
      usernameTC = TextEditingController(),
      passwordTc = TextEditingController(),
      paidLeaveTC = TextEditingController(
          // text: kDebugMode ? "2" : null,
          ),
      wfhTC = TextEditingController(
          // text: kDebugMode ? "2" : null,
          ),
      casualSickTC = TextEditingController(
          // text: kDebugMode ? "2" : null,
          ),
      fullNameTc = TextEditingController(),
      companyIDTc = TextEditingController(),
      organizationTc = TextEditingController();
  var scheduleNameTC = TextEditingController();
  var isEmployeeSignup = true.obs;
  var workingDays = <WorkingDaysModel>[].obs;
  var startTime = Rxn<TimeOfDay?>(null), endTime = Rxn<TimeOfDay?>(null);
  var formKey = GlobalKey<FormState>();
  var isSaveLoading = false.obs;
  // Biometric
  final LocalAuthentication auth = LocalAuthentication();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  void onInit() {
    workingDays.value = <String>[
      "Monday", // MONDAY
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ]
        .map(
          (e) => WorkingDaysModel(
            label: e,
            code: e.toUpperCase(),
            isSelected: kDebugMode,
          ),
        )
        .toList();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    fetchAllBranches();
  }

  @override
  void onClose() {
    emailTc.dispose();
    passwordTc.dispose();
    super.onClose();
  }

  onWorkingDaysChange(int index) {
    workingDays[index].isSelected = !workingDays[index].isSelected;
    workingDays.refresh();
  }

  void gotToLoginPage() {
    Get.offAllNamed(Routes.LOGIN_PAGE);
  }

  Future<void> signUP() async {
    List<WorkingDaysModel> tempWorkingdays = List.from(workingDays.value);
    tempWorkingdays.removeWhere((element) => !element.isSelected);
    workingDays.refresh();
    final deviceId = await Get.find<AuthController>().getDeviceId();

    // print(tempWorkingdays.map((e) => e.code).toList());
    if (isEmployeeSignup.value == false) {
      role = "Admin";
    } else {
      role = "Employee";
    }
    if (formKey.currentState?.validate() ?? false || !isSaveLoading.value) {
      if (emailTc.text.trim().isEmpty ||
          passwordTc.text.isEmpty ||
          fullNameTc.text.isEmpty ||
          branches.isEmpty ||
          departments.isEmpty ||
          selectedDepartment.value == null ||
          selectedItem.value == null) {
        showErrorSnack("Please fill all fields");
        return;
      }
      if (role == "Admin" &&
          (
              //startTime.value == null ||
              // endTime.value == null ||
              branches.isEmpty ||
                  departments.isEmpty ||
                  selectedDepartment.value == null ||
                  selectedItem.value == null
          //scheduleNameTC.text.trim().isEmpty ||
          //workingDays.value.where((element) => element.isSelected).isEmpty
          )) {
        showErrorSnack("Please fill all  fields");
        return;
      }
      isSaveLoading.value = true;
      var payload = {};
      List<WorkingDaysModel> tempWorkingdays = List.from(workingDays.value);
      tempWorkingdays.removeWhere((element) => !element!.isSelected);

      if (role == "Employee") {
        payload = {
          "username": emailTc.text.trim(),
          "password": passwordTc.text.trim(),
          "fullName": fullNameTc.text,
          "roleType": role, //UserRoleType.superAdmin.code,
          "companyID": selectedItem.value?.id,
          "departmentID": selectedDepartment.value?.id,
          "deviceId": deviceId,
        };
      } else {
        payload = {
          "username": emailTc.text.trim(),
          "password": passwordTc.text.trim(),
          "fullName": fullNameTc.text,
          "roleType": role, //UserRoleType.superAdmin.code,
          "companyID": selectedItem.value?.id,
          /* "inTime": formatTimeOfDay(startTime.value!),
          "outTime": formatTimeOfDay(endTime.value!),
          "workingDays": tempWorkingdays.map((e) => e.code).toList(),
          "perMonthPL": num.tryParse(paidLeaveTC.text.trim()),
          "perMonthSLCL": num.tryParse(casualSickTC.text.trim()),
          "perMonthWFH": num.tryParse(paidLeaveTC.text.trim()),
          "sh_name": scheduleNameTC.text,*/
          "departmentID": selectedDepartment.value?.id,
          "deviceId": deviceId,
        };
      }
      ApiController.to
          .callPOSTAPI(
        url: APIUrlsService.to.signup,
        body: payload,
      )
          .then((resp) async {
        isSaveLoading.value = false;
        var pass = passwordTc.text.trim();
        // print("*************************Password: $pass");

        //print("*************************Response: $resp");
        //if (resp is Map<String, dynamic>) {
        if (resp['status'] == true) {
          // Save credentials for biometric login
          await saveCredentialsForBiometrics(
              emailTc.text.trim(), passwordTc.text);
          // await AppStorageController.to
          //   .login(resp['data'] as Map<String, dynamic>);

          showSuccessSnack("User Created Successfully.");
          Get.offAllNamed(Routes.LOGIN_PAGE);
        } else {
          showErrorSnack(resp['errorMsg']?.toString() ?? "Unknown error.");
        }
        /*  } else {
          showErrorSnack("Invalid API response format.");
        }*/
      }).catchError((e) {
        isSaveLoading.value = false;
        showErrorSnack((e['errorMsg'] ?? (e)).toString());
      });
    }
  }

  Future<void> fetchAllBranches() async {
    try {
      final resp = await ApiController.to
          .callGETAPI(
        url: APIUrlsService.to.fetchBranches,
      )
          .catchError((e) {
        showErrorSnack((e['errorMsg'] ?? (e)).toString());
      });

      if (resp != null && resp is Map) {
        if (resp['status'] == true && resp['data'] is List) {
          branches.assignAll(
            (resp["data"] as List).map((e) => Branch.fromJson(e)).toList(),
          );
          /* if (branches.isNotEmpty) {
          selectedItem.value = branches.first;
        } */
        } else {
          final errMsg =
              (resp['errorMsg'] ?? "Unknown error occurred").toString();
          showErrorSnack(errMsg); // always String now
        }
      } else {
        showErrorSnack("Invalid response from server");
      }
    } catch (e) {
      //showErrorSnack("No Branches Found");
    }
  }

  void onBranchSelected(Branch? branch) {
    selectedItem.value = branch;
    if (branch != null) {
      // call API or filter departments by branch
      fetchAllDepts(branch.id);
    } else {
      departments.clear();
      selectedDepartment.value = null;
    }
  }

  Future<void> fetchAllDepts(int branchId) async {
    try {
      final resp = await ApiController.to
          .callGETAPI(
        url: APIUrlsService.to.fetchDepts(branchId.toString()),
      )
          .catchError((e) {
        showErrorSnack((e['errorMsg'] ?? (e)).toString());
      });

      if (resp != null && resp is Map) {
        if (resp['status'] == true && resp['data'] is List) {
          departments.assignAll(
            (resp["data"] as List).map((e) => Departments.fromJson(e)).toList(),
          );
          /* if (branches.isNotEmpty) {
          selectedItem.value = branches.first;
        } */
        } else {
          final errMsg =
              (resp['errorMsg'] ?? "Unknown error occurred").toString();
          showErrorSnack(errMsg); // always String now
        }
      } else {
        showErrorSnack("Invalid response from server");
      }
    } catch (e) {
      //showErrorSnack("No Branches Found");
    }
  }

  /// Save credentials securely after signup
  Future<void> saveCredentialsForBiometrics(
      String username, String password) async {
    await secureStorage.write(key: 'username', value: username);
    await secureStorage.write(key: 'password', value: password);
  }

  void increment() => count.value++;
}
