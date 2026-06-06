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
  String? password;
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
      this.branchName,
      this.password});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    userID = json['id']?.toString();
    companyID = json['Branch_id']?.toString();
    departmentID = json['departmentID']?.toString();
    departmentName = json['departmentName']?.toString();
    adminID = json['adminID']?.toString();
    username = json['email']?.toString();
    fullName = json['name']?.toString();
    createdAt = json['createdAt']?.toString();
    branchName = json['branchName']?.toString();
    if (json['position'] != null) {
      roleType = UserRoleType.fromString(json['position'].toString());
    }
    totalLeaveBalance = int.tryParse(json['totalLeaveBalance']?.toString() ?? '0');
    totalLeaveApproved = int.tryParse(json['totalLeaveApproved']?.toString() ?? '0');
    totalLeavePending = int.tryParse(json['totalLeavePending']?.toString() ?? '0');
    totalLeaveCancelled = int.tryParse(json['totalLeaveCancelled']?.toString() ?? '0');
    companyName = json['CompanyName']?.toString();
    if (json['wrokingDays'] != null) {
      final raw = json['wrokingDays'];
      final decoded = raw is String ? jsonDecode(raw) : raw;
      if (decoded is List) {
        wrokingDays = decoded.map((e) => e.toString()).toList();
      }
    }
    inTime = json['inTime']?.toString();
    outTime = json['outTime']?.toString();
    employeeApproved = json['employeeApproved']?.toString() == '1';
    rejectedReason = json['rejectedReason']?.toString();
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
