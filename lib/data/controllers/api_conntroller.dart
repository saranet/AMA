import 'dart:convert';

import 'package:get/get.dart';
import 'package:ama/data/controllers/api_url_service.dart';

class ApiController extends GetConnect {
  static ApiController to =
      Get.isRegistered<ApiController>() ? Get.find() : Get.put(ApiController());

  @override
  void onInit() {
    httpClient.baseUrl = APIUrlsService.to.baseURL;
    super.onInit();
  }

  Future<dynamic> callGETAPI({
    required String url,
  }) async {
    final resp = await get(Uri.encodeFull(url)).catchError((e) {
      throw e;
    });
    if (resp.isOk) {
      if (resp.body is String) {
        return jsonDecode(resp.body);
      } else {
        return resp.body; // Already a Map/List
      }
    } else {
      throw resp.body ?? resp.statusText;
    }
  }

  Future<dynamic> callPOSTAPI({
    required String url,
    required dynamic body,
  }) async {
    final resp = await post(url, body).catchError((e) {
      throw e;
    });
    if (resp.isOk) {
      return resp.body;
    } else {
      throw resp.body ?? resp.statusText;
    }
  }
}
