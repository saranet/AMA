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
    id = json['schedule_id']?.toString();
    slug = json['slug']?.toString();

    if (json['emp_name'] != null) {
      final raw = json['emp_name'];
      final decoded = raw is String ? jsonDecode(raw) : raw;
      if (decoded is List) usersName = decoded.map((e) => e.toString()).toList();
    }
    if (json['emp_id'] != null) {
      final raw = json['emp_id'];
      final decoded = raw is String ? jsonDecode(raw) : raw;
      if (decoded is List) usersID = decoded.map((e) => e.toString()).toList();
    }
    inTime = json['time_in']?.toString();
    outTime = json['time_out']?.toString();
    if (json['wrokingDays'] != null) {
      final raw = json['wrokingDays'];
      final decoded = raw is String ? jsonDecode(raw) : raw;
      if (decoded is List) workingDays = decoded.map((e) => e.toString()).toList();
    }
    created_by = json['created_by']?.toString();
    created_at = json['created_at']?.toString();
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
