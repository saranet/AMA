class AllowedZone {
  final double lat;
  final double lng;
  final double radius;

  AllowedZone({required this.lat, required this.lng, required this.radius});

  factory AllowedZone.fromJson(Map<String, dynamic> json) {
    return AllowedZone(
      lat: double.tryParse(json['latitude']?.toString() ?? '0') ?? 0,
      lng: double.tryParse(json['longitude']?.toString() ?? '0') ?? 0,
      radius: double.tryParse(json['distance']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'latitude': lat.toString(),
        'longitude': lng.toString(),
        'distance': radius.toString(),
      };
}
