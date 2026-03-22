import 'package:ama/utils/helper_function.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../model/AllowedZone.dart';
import 'ZoneStorageService.dart';
import 'package:ama/data/controllers/api_url_service.dart';
import 'package:ama/data/controllers/api_conntroller.dart';
import 'package:ama/data/controllers/app_storage_service.dart';

class AllowedZoneService extends GetxService {
  static AllowedZoneService get to => Get.find();

  final RxList<AllowedZone> allowedZones = <AllowedZone>[].obs;
  final _box = GetStorage();
  static const _lastRefreshKey = 'zones_last_refresh';

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
      ApiController.to
          .callGETAPI(
        url: url,
      )
          .catchError((e) {
        showErrorSnack(e.toString());
      }).then((resp) {
        if (resp != null && resp['status'] == true && resp['data'] != null) {
          List data = resp['data'];
          final zones = data
              .map((e) => AllowedZone.fromJson(Map<String, dynamic>.from(e)))
              .toList();
          ZoneStorageService.saveZones(zones);
          allowedZones.value = zones;
          print(
              "AllowedZoneService.loadZonesFromAPI: Loaded ${zones.length} zones");
        }
      });
    } catch (e) {
      print("AllowedZoneService.loadZonesFromAPI error: $e");
    }
  }

  void _refreshZonesOncePerDay() {
    final last = _box.read<String?>(_lastRefreshKey);
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (last != today) {
      loadZonesFromAPI();
      _box.write(_lastRefreshKey, today);
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
