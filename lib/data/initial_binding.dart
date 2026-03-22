import 'package:get/get.dart';
import 'package:ama/data/controllers/api_conntroller.dart';
import 'package:ama/data/controllers/api_url_service.dart';

class IntialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(APIUrlsService()); // api URL
    Get.put(ApiController()); // for calling api
  }
}
