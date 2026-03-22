import 'package:ama/app/modules/Auth/services/OfflineAttendance.dart';
import 'package:get_storage/get_storage.dart';

class OfflineAttendanceStorage {
  static const _key = 'offline_attendance_queue';
  static final _box = GetStorage();

  static List<OfflineAttendance> loadAll() {
    final raw = _box.read<List>(_key) ?? [];
    return raw
        .map((e) => OfflineAttendance.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Future<void> saveAll(List<OfflineAttendance> items) async {
    final raw = items.map((i) => i.toJson()).toList();
    await _box.write(_key, raw);
  }

  static Future<void> add(OfflineAttendance item) async {
    final list = loadAll();
    list.add(item);
    await saveAll(list);
  }

  static Future<void> removeById(String id) async {
    final list = loadAll();
    list.removeWhere((e) => e.id == id);
    await saveAll(list);
  }

  static Future<void> clear() async {
    await _box.remove(_key);
  }
}
