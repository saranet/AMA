import 'package:get_storage/get_storage.dart';
import '../model/AllowedZone.dart';

class ZoneStorageService {
  static const _key = 'allowedZones';
  static final _box = GetStorage();

  static List<AllowedZone> loadZones() {
    final raw = _box.read<List>(_key) ?? [];
    print("local loadZones: Loaded ${raw.length} zones from storage");
    return raw
        .map((e) => AllowedZone.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static void saveZones(List<AllowedZone> zones) {
    final raw = zones.map((z) => z.toJson()).toList();
    _box.write(_key, raw);
  }
}
