import 'dart:convert';

class AttendenceModel {
  String? id;
  String? userID;
  String? companyID;
  List<String>? inTimes;
  List<String>? outTimes;
  List<String>? breakInTime;
  List<String>? breakOutTime;
  String? createdAt;

  AttendenceModel({
    this.id,
    this.userID,
    this.companyID,
    this.inTimes,
    this.outTimes,
    this.breakInTime,
    this.breakOutTime,
    this.createdAt,
  });

  AttendenceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userID = json['userID'];
    companyID = json['companyID'];
    // Handle inTimes
    if (json['inTime'] != null) {
      if (json['inTime'] is String) {
        // stored as JSON string in DB
        inTimes = jsonDecode(json['inTime']).cast<String>();
      } else if (json['inTime'] is List) {
        inTimes = (json['inTime'] as List).map((e) => e.toString()).toList();
      }
    }

    // Handle outTimes
    if (json['outTime'] != null) {
      if (json['outTime'] is String) {
        outTimes = jsonDecode(json['outTime']).cast<String>();
      } else if (json['outTime'] is List) {
        outTimes = (json['outTime'] as List).map((e) => e.toString()).toList();
      }
    }

    if (json['breakInTimes'] != null) {
      if (json['breakInTimes'] is String) {
        breakInTime = jsonDecode(json['breakInTimes']).cast<String>();
      } else if (json['breakInTimes'] is List) {
        breakInTime =
            (json['breakInTimes'] as List).map((e) => e.toString()).toList();
      }
    }

    // Handle breakOutTimes
    if (json['breakOutTimes'] != null) {
      if (json['breakOutTimes'] is String) {
        breakOutTime = jsonDecode(json['breakOutTimes']).cast<String>();
      } else if (json['breakOutTimes'] is List) {
        breakOutTime =
            (json['breakOutTimes'] as List).map((e) => e.toString()).toList();
      }
    }
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userID'] = userID;
    data['companyID'] = companyID;
    data['inTimes'] = inTimes;
    data['outTimes'] = outTimes;
    data['breakInTimes'] = breakInTime;
    data['breakOutTimes'] = breakOutTime;
    data['createdAt'] = createdAt;
    return data;
  }
}
