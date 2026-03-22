import 'dart:convert';

class ScheduleModel {
  String? id;
  String? slug;
  List<String>? usersName;
  List<String>? usersID;
  String? inTime;
  String? outTime;
  List<String>? workingDays;
  String? created_by;
  String? created_at;
  // String? updated_at;

  ScheduleModel({
    this.id,
    this.usersName,
    this.usersID,
    this.inTime,
    this.outTime,
    this.workingDays,
    this.created_by,
    this.created_at,
    // this.updated_at,
  });

  ScheduleModel.fromJson(Map<String, dynamic> json) {
    id = json['schedule_id'];
    slug = json['slug'];

    if (json['emp_name'] != null) {
      usersName = jsonDecode(json['emp_name']).cast<String>();
    }
    if (json['emp_id'] != null) {
      usersID = jsonDecode(json['emp_id']).cast<String>();
    }
    // companyID = json['companyID'];
    inTime = json['time_in'];
    outTime = json['time_out'];
    if (json['wrokingDays'] != null) {
      workingDays = jsonDecode(json['wrokingDays']).cast<String>();
    }
    created_by = json['created_by'];
    created_at = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['userID'] = usersID;
    data['userName'] = usersName;

    data['inTime'] = inTime;
    data['outTime'] = outTime;
    data['workingDays'] = workingDays;
    data['created_by'] = created_by;
    data['created_at'] = created_at;
    return data;
  }
}
