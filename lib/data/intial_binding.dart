import 'package:ama/app/modules/Auth/controllers/auth_controller.dart';
import 'package:ama/app/modules/Auth/services/AllowedZoneService.dart';
import 'package:ama/data/controllers/app_storage_service.dart';
import 'package:get/get.dart';
import 'package:ama/data/controllers/api_conntroller.dart';
import 'package:ama/data/controllers/api_url_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AppStorageController()); // for local storage
    Get.put(APIUrlsService()); // api URL
    Get.put(ApiController()); // for calling api
    Get.put(AuthController()); // auth controller
    Get.put(AllowedZoneService()); // allowed zone service
  }
}
