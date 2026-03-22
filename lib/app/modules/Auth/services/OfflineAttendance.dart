class OfflineAttendance {
  final String id; // local id (uuid)
  final String activityType; // IN, OUT, BREAKIN, BREAKOUT
  final String time; // ISO or your server format or toHOUR24MINUTESECOND
  final double lat;
  final double lng;
  final Map<String, dynamic>? extra; // optional extra fields

  OfflineAttendance({
    required this.id,
    required this.activityType,
    required this.time,
    required this.lat,
    required this.lng,
    this.extra,
  });

  factory OfflineAttendance.fromJson(Map<String, dynamic> json) =>
      OfflineAttendance(
        id: json['id'],
        activityType: json['activityType'],
        time: json['time'],
        lat: (json['lat'] as num).toDouble(),
        lng: (json['lng'] as num).toDouble(),
        extra: json['extra'] == null
            ? null
            : Map<String, dynamic>.from(json['extra']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'activityType': activityType,
        'time': time,
        'lat': lat,
        'lng': lng,
        'extra': extra,
      };
}
