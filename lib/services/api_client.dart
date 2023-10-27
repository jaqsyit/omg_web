import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:omg/constants/urls.dart';
import 'package:omg/services/storage_helper.dart';

class ApiClient {

  ApiClient();

  Future<http.Response> get(
    String url, {
    Map<String, String>? parameters,
    bool withToken = true,
  }) async {
    final storage = StorageManager();
    String requestURL = '$MID_URL$url';

    String? accessToken;

    if (withToken) {
      accessToken = await storage.getAccessToken();
    }

    try {
      final response = await http.get(
        Uri.http(BASE_URL, requestURL, parameters),
        headers: _buildHeaders(withToken, accessToken),
      );

      return response;
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<http.Response> post(
    String url, {
    Map<String, String>? parameters,
    bool withToken = true,
    Map<String, dynamic>? body,
    Object? jsonBody,
  }) async {
    final storage = StorageManager();
    String requestURL = '$MID_URL$url';

    String? accessToken;

    if (withToken) {
      accessToken = await storage.getAccessToken();
    }

    try {
      final response = await http.post(
        Uri.http(BASE_URL, requestURL, parameters),
        headers: _buildHeaders(withToken, accessToken),
        body: body ?? jsonBody,
      );

      return response;
    } catch (e) {
      return _handleError(e);
    }
  }

  Map<String, String> _buildHeaders(bool withToken, String? accessToken) {
    return withToken
        ? {
            'Authorization': 'Bearer $accessToken',
            'Accept': 'application/json',
          }
        : {'Accept': 'application/json'};
  }

  http.Response _handleError(dynamic e) {
    if (e is SocketException) {
      return _createErrorResponse('Проверьте интернет подключение');
    } else if (e is TimeoutException) {
      return _createErrorResponse('Долгая загрузка');
    } else {
      return _createErrorResponse('Неизвестная ошибка');
    }
  }

  http.Response _createErrorResponse(String message) {
    final errorResponse = {
      'message': message,
    };
    return http.Response(jsonEncode(errorResponse), 500);
  }
}
