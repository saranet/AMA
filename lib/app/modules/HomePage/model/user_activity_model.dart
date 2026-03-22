class UserActivityModel {
  String? activityID;
  String? createdAt;

  List<CheckIn>? checkIn;
  List<OutTime>? outTime;
  List<String>? breakInTime;
  List<String>? breakOutTime;

  UserActivityModel({
    this.activityID,
    this.createdAt,
    this.checkIn,
    this.outTime,
    this.breakInTime,
    this.breakOutTime,
  });

  UserActivityModel.fromJson(Map<String, dynamic> json) {
    activityID = json['activityID'];
    createdAt = json['date'];

    // Safe parse for checkIn (handle map or list)
    final checkInData = json['checkIn'];
    if (checkInData is List) {
      checkIn = checkInData.map((e) => CheckIn.fromJson(e)).toList();
    } else if (checkInData is Map) {
      checkIn = [CheckIn.fromJson(Map<String, dynamic>.from(checkInData))];
    }

    // Safe parse for outTime (handle map or list)
    final outTimeData = json['outTime'];
    if (outTimeData is List) {
      outTime = outTimeData.map((e) => OutTime.fromJson(e)).toList();
    } else if (outTimeData is Map) {
      outTime = [OutTime.fromJson(Map<String, dynamic>.from(outTimeData))];
    }

    // Break times
    breakInTime =
        (json['breakInTime'] as List?)?.map((e) => e.toString()).toList();
    breakOutTime =
        (json['breakOutTime'] as List?)?.map((e) => e.toString()).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['activityID'] = activityID;
    data['date'] = createdAt;
    if (checkIn != null) {
      data['checkIn'] = checkIn!.map((v) => v.toJson()).toList();
    }
    if (outTime != null) {
      data['outTime'] = outTime!.map((v) => v.toJson()).toList();
    }
    data['breakInTime'] = breakInTime;
    data['breakOutTime'] = breakOutTime;
    return data;
  }
}

class CheckIn {
  String? inTime;
  String? msg;

  CheckIn({this.inTime, this.msg});

  CheckIn.fromJson(Map<String, dynamic> json) {
    inTime = json['inTime'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() => {
        'inTime': inTime,
        'msg': msg,
      };
}

class OutTime {
  String? outTime;
  String? msg;

  OutTime({this.outTime, this.msg});

  OutTime.fromJson(Map<String, dynamic> json) {
    outTime = json['outTime'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() => {
        'outTime': outTime,
        'msg': msg,
      };
}

enum UserPerformActivty {
  IN,
  OUT,
  BREAKIN,
  BREAKOUT; // name => BREAKOUT

  String get label {
    return switch (this) {
      IN => "Swipe to Check in.",
      BREAKIN => "Swipe to Break in.",
      BREAKOUT => "Swipe to Break out.",
      OUT => "Swipe to Check out.",
    };
  }
}
