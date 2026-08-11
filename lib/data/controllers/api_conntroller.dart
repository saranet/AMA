import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:ama/data/controllers/api_url_service.dart';

class ApiController extends GetConnect {
  static ApiController to =
      Get.isRegistered<ApiController>() ? Get.find() : Get.put(ApiController());

  // Configuration
  static const Duration _timeout = Duration(seconds: 15);
  static const int _maxRetries = 2;
  static const Duration _retryDelay = Duration(seconds: 1);

  @override
  void onInit() {
    httpClient.baseUrl = APIUrlsService.to.baseURL;
    httpClient.timeout = _timeout;
    super.onInit();
  }

  /// Determines if an error is recoverable and worth retrying
  bool _isRetryableError(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    return errorStr.contains('connection closed') ||
        errorStr.contains('connection reset') ||
        errorStr.contains('socket') ||
        errorStr.contains('timeout') ||
        errorStr.contains('network is unreachable') ||
        error is SocketException ||
        error is HttpException;
  }

  Future<dynamic> callGETAPI({
    required String url,
    int retryAttempt = 0,
  }) async {
    try {
      // GetConnect's own timeout covers connecting and sending, but not
      // reading the response body — that read can hang forever. Wrap the
      // whole call so no request can outlive its budget.
      final resp = await get(Uri.encodeFull(url)).timeout(_timeout);

      if (resp.isOk) {
        if (resp.body is String) {
          try {
            return jsonDecode(resp.body);
          } catch (e) {
            print("⚠️ JSON parse error: $e");
            return resp.body;
          }
        }
        return resp.body;
      } else {
        // Non-200 response — retry on 5xx server errors
        if ((resp.statusCode ?? 0) >= 500 && retryAttempt < _maxRetries) {
          print(
              '🔄 Server error ${resp.statusCode}, retrying (${retryAttempt + 1}/$_maxRetries)...');
          await Future.delayed(_retryDelay * (retryAttempt + 1));
          return callGETAPI(url: url, retryAttempt: retryAttempt + 1);
        }
        throw resp.body ??
            resp.statusText ??
            'Server error: ${resp.statusCode}';
      }
    } catch (e) {
      // Network errors — retry
      if (_isRetryableError(e) && retryAttempt < _maxRetries) {
        print(
            '🔄 Connection error, retrying (${retryAttempt + 1}/$_maxRetries): $e');
        await Future.delayed(_retryDelay * (retryAttempt + 1));
        return callGETAPI(url: url, retryAttempt: retryAttempt + 1);
      }
      // After max retries, throw a friendly message
      if (_isRetryableError(e)) {
        throw 'Connection problem. Please check your internet and try again.';
      }
      rethrow;
    }
  }

  Future<dynamic> callPOSTAPI({
    required String url,
    required dynamic body,
    int retryAttempt = 0,
  }) async {
    try {
      final resp = await post(url, body).timeout(_timeout);

      if (resp.isOk) {
        if (resp.body is String) {
          try {
            return jsonDecode(resp.body);
          } catch (e) {
            print("⚠️ JSON parse error: $e");
            return resp.body;
          }
        }
        return resp.body;
      } else {
        if ((resp.statusCode ?? 0) >= 500 && retryAttempt < _maxRetries) {
          print(
              '🔄 Server error ${resp.statusCode}, retrying (${retryAttempt + 1}/$_maxRetries)...');
          await Future.delayed(_retryDelay * (retryAttempt + 1));
          return callPOSTAPI(
              url: url, body: body, retryAttempt: retryAttempt + 1);
        }
        throw resp.body ??
            resp.statusText ??
            'Server error: ${resp.statusCode}';
      }
    } catch (e) {
      if (_isRetryableError(e) && retryAttempt < _maxRetries) {
        print(
            '🔄 Connection error, retrying (${retryAttempt + 1}/$_maxRetries): $e');
        await Future.delayed(_retryDelay * (retryAttempt + 1));
        return callPOSTAPI(
            url: url, body: body, retryAttempt: retryAttempt + 1);
      }
      if (_isRetryableError(e)) {
        throw 'Connection problem. Please check your internet and try again.';
      }
      rethrow;
    }
  }
}
