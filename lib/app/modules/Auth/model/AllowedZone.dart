class AllowedZone {
  final double lat;
  final double lng;
  final double radius;

  AllowedZone({required this.lat, required this.lng, required this.radius});

  factory AllowedZone.fromJson(Map<String, dynamic> json) {
    return AllowedZone(
      lat: double.parse(json['latitude'] as String),
      lng: double.parse(json['longitude'] as String),
      radius: double.parse(json['distance'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'latitude': lat.toString(),
        'longitude': lng.toString(),
        'distance': radius.toString(),
      };
}
