import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ama/app/models/team_members_model.dart';
import 'package:ama/utils/theme/app_colors.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';

class LeaveActivityModel {
  String? id;
  String? userID;
  String? companyID;
  MembersData? approvalTo;
  DateTime? applyDate;
  LeaveActivityState? leaveStatus;
  DateTime? fromdate;
  DateTime? todate;
  String? leaveReason;
  String? rejectedReason;
  MembersData? user;

  LeaveActivityModel({
    this.id,
    this.userID,
    this.companyID,
    this.approvalTo,
    this.applyDate,
    this.leaveStatus,
    this.fromdate,
    this.todate,
    this.leaveReason,
    this.rejectedReason,
    this.user,
  });

  LeaveActivityModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    userID = json['userID']?.toString();
    companyID = json['companyID']?.toString();
    if (json['employee'] != null) {
      user = MembersData.fromJson(json['employee']);
    }
    if (json['approvalTo'] != null) {
      approvalTo = MembersData.fromJson(json['approvalTo']);
    }
    if (json['status'] != null) {
      leaveStatus = LeaveActivityState.fromStrings(json['status'].toString());
    }
    if (json['fromdate'] != null) {
      fromdate = DateFormat("yyyy-MM-dd").parse(json['fromdate'].toString());
    }
    if (json['todate'] != null) {
      todate = DateFormat("yyyy-MM-dd").parse(json['todate'].toString());
    }
    if (json['applyDate'] != null) {
      applyDate = DateFormat("yyyy-MM-dd").parse(json['applyDate'].toString());
    }
    leaveReason = json['leaveReason']?.toString();
    rejectedReason = json['rejectedReason']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userID'] = userID;
    data['companyID'] = companyID;
    data['approvalTo'] = approvalTo;
    data['applyDate'] = applyDate;
    data['leaveStatus'] = leaveStatus;
    data['fromdate'] = fromdate;
    data['todate'] = todate;
    data['leaveReason'] = leaveReason;
    data['rejectedReason'] = rejectedReason;
    return data;
  }
}

enum LeaveActivityState {
  pending,
  approved,
  rejected;

  /// Returns list of all enum values — used for iterating over tabs
  static List<LeaveActivityState> get all => LeaveActivityState.values;

  /// Returns hardcoded English list (kept for backward compatibility)
  static List<String> get list {
    return ["Pending", "Approved", "Rejected"];
  }

  static LeaveActivityState? fromStrings(String val) {
    switch (val.toUpperCase()) {
      case "PENDING":
        return LeaveActivityState.pending;
      case "APPROVED":
        return LeaveActivityState.approved;
      case "REJECTED":
        return LeaveActivityState.rejected;
    }
    return null;
  }

  /// Backend status code (always English — don't translate)
  String get code {
    return switch (this) {
      pending => "PENDING",
      approved => "APPROVED",
      rejected => "REJECTED",
    };
  }

  /// English display name
  String get getName {
    return switch (this) {
      pending => "Pending",
      approved => "Approved",
      rejected => "Rejected",
    };
  }

  /// ✅ Translated display name — works in both English and Arabic
  String get label {
    final l10n = AppLocalizations.of(Get.context!)!;
    return switch (this) {
      pending => l10n.pending,
      approved => l10n.approved,
      rejected => l10n.rejected,
    };
  }

  Color get getColor {
    return switch (this) {
      pending => AppColors.kBlue900,
      approved => AppColors.kGreen700,
      rejected => AppColors.kFailureRed,
    };
  }
}
