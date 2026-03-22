import 'dart:convert';

import 'package:ama/data/app_enums.dart';

class UserDataModel {
  String? userID;
  String? companyID;
  String? departmentID;
  String? departmentName;
  String? adminID;
  String? username;
  String? fullName;
  String? createdAt;
  UserRoleType? roleType;
  int? totalLeaveBalance;
  int? totalLeaveApproved;
  int? totalLeavePending;
  int? totalLeaveCancelled;
  String? companyName;
  List<String>? wrokingDays;
  String? inTime;
  String? outTime;
  bool? employeeApproved;
  String? rejectedReason;
  String? branchName;
  UserDataModel(
      {this.userID,
      this.companyID,
      this.adminID,
      this.username,
      this.fullName,
      this.createdAt,
      this.roleType,
      this.totalLeaveBalance,
      this.totalLeaveApproved,
      this.totalLeavePending,
      this.totalLeaveCancelled,
      this.companyName,
      this.wrokingDays,
      this.inTime,
      this.outTime,
      this.employeeApproved,
      this.rejectedReason,
      this.departmentID,
      this.departmentName,
      this.branchName});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    userID = json['id'];
    companyID = json['Branch_id'];
    departmentID = json['departmentID'];
    departmentName = json['departmentName'];
    adminID = json['adminID'];
    username = json['email'];
    fullName = json['name'];
    createdAt = json['createdAt'];
    branchName = json['branchName'];
    if (json['position'] != null) {
      roleType = UserRoleType.fromString(json['position']);
    }
    totalLeaveBalance = int.tryParse(json['totalLeaveBalance'].toString());
    totalLeaveApproved = int.tryParse(json['totalLeaveApproved'].toString());
    totalLeavePending = int.tryParse(json['totalLeavePending'].toString());
    totalLeaveCancelled = int.tryParse(json['totalLeaveCancelled'].toString());
    companyName = json['CompanyName'];
    if (json['wrokingDays'] != null) {
      final decoded = jsonDecode(json['wrokingDays']) ?? '';
      if (decoded is List) {
        wrokingDays = decoded.map((e) => e.toString()).toList();
      }
    }
    inTime = json['inTime'];
    outTime = json['outTime'];
    employeeApproved =
        json['employeeApproved'].toString() == '1' ? true : false;
    rejectedReason = json['rejectedReason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = userID;
    data['companyID'] = companyID;
    data['departmentID'] = departmentID;
    data['departmentName'] = departmentName;
    data['adminID'] = adminID;
    data['username'] = username;
    data['fullName'] = fullName;
    data['createdAt'] = createdAt;
    data['roleType'] = roleType?.code;
    data['totalLeaveBalance'] = totalLeaveBalance;
    data['totalLeaveApproved'] = totalLeaveApproved;
    data['totalLeavePending'] = totalLeavePending;
    data['totalLeaveCancelled'] = totalLeaveCancelled;
    data['companyName'] = companyName;
    data['wrokingDays'] = wrokingDays;
    data['inTime'] = inTime;
    data['outTime'] = outTime;
    data['employeeApproved'] = employeeApproved;
    data['rejectedReason'] = rejectedReason;
    data['branchName'] = branchName;
    return data;
  }
}
