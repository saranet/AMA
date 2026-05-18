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
    allowedZones.value = ZoneStorageService.loadZones();
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

  bool isWithinAllowedZone(Position position) {
    if (allowedZones.isEmpty) return false;
    for (final z in allowedZones) {
      final d = Geolocator.distanceBetween(
          position.latitude, position.longitude, z.lat, z.lng);
      if (d <= z.radius) return true;
    }
    return false;
  }
}
