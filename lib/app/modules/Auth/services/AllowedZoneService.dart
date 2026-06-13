import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../model/AllowedZone.dart';
import 'ZoneStorageService.dart';
import 'package:ama/data/controllers/api_url_service.dart';
import 'package:ama/data/controllers/api_conntroller.dart';

class AllowedZoneService extends GetxService {
  static AllowedZoneService get to => Get.find();

  final RxList<AllowedZone> allowedZones = <AllowedZone>[].obs;

  @override
  void onInit() {
    super.onInit();
    // load local immediately
    try {
      allowedZones.value = ZoneStorageService.loadZones();
    } catch (_) {}
    // fetch remote (silent)
    loadZonesFromAPI();
    // daily refresh
    //_refreshZonesOncePerDay();
  }

  Future<void> loadZonesFromAPI() async {
    try {
      final url = APIUrlsService.to.allowedZones();
      final resp = await ApiController.to.callGETAPI(url: url);
      if (resp != null && resp['status'] == true && resp['data'] != null) {
        final List data = resp['data'];
        final zones = data
            .map((e) => AllowedZone.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        ZoneStorageService.saveZones(zones);
        allowedZones.value = zones;
      }
    } catch (_) {
      // Silent failure — local zones loaded in onInit serve as fallback
    }
  }

  /// Returns true if [position] falls inside any allowed zone.
  ///
  /// The GPS fix carries an `accuracy` value (the radius, in metres, of 68%
  /// confidence). We subtract that from the measured distance so a reading
  /// that is *probably* inside the zone — but reported imprecisely, as is
  /// common on iOS — is not rejected. The buffer is capped so a wildly
  /// inaccurate fix (e.g. when "Precise Location" is off) can't wave the user
  /// through from kilometres away.
  bool isWithinAllowedZone(Position position) {
    if (allowedZones.isEmpty) return false;

    // Cap how much slack a single fix can earn (metres).
    const double maxAccuracyBuffer = 100.0;
    final double buffer =
        position.accuracy.clamp(0.0, maxAccuracyBuffer).toDouble();

    for (final z in allowedZones) {
      final d = Geolocator.distanceBetween(
          position.latitude, position.longitude, z.lat, z.lng);
      if (d - buffer <= z.radius) return true;
    }
    return false;
  }
}
