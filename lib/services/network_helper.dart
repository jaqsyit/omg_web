import 'package:http/http.dart' as http;
import 'package:omg/services/api_client.dart';
import 'package:omg/services/json_decoder.dart';

class NetworkHelper {
  final ApiClient apiClient;

  NetworkHelper() : apiClient = ApiClient();

  Future<dynamic> get({
    required String url,
    Map<String, String>? parameters,
    bool withToken = true,
  }) async {
    final response =
        await apiClient.get(url, parameters: parameters, withToken: withToken);
    return _handleResponse(response);
  }

  Future<dynamic> post({
    required String url,
    Map<String, String>? parameters,
    bool withToken = true,
    Map<String, dynamic>? body,
    Object? jsonBody,
  }) async {
    final response = await apiClient.post(url,
        parameters: parameters,
        withToken: withToken,
        body: body,
        jsonBody: jsonBody);
    return _handleResponse(response);
  }

  Future<dynamic> delete({
  required String url,
  Map<String, String>? parameters,
  bool withToken = true,
}) async {
  final response = await apiClient.delete(url,parameters: parameters);
  return _handleResponse(response);
}

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 401) {
      return 'refresh token';
    } 
    else {
      final Map<String, dynamic> answerMap =
          JsonDecoder().responseToMap(response);
      if (answerMap.containsKey('message')) {
        return answerMap['message'];
      } else {
        return 'Неизвестная ошибка';
      }
    }
  }

  // Future<void> _refreshToken() async {
  //   final storage = StorageManager();
  //   final String? refreshToken = await storage.getRefreshToken();

  //   if (refreshToken != null) {
  //     const String tokenUrl =
  //         'https://mobile.mektep.edu.kz/api_ok_edus/public/api/ru/refresh-token';

  //     try {
  //       final http.Response response = await http.get(
  //         Uri.parse(tokenUrl),
  //         headers: {
  //           'Authorization': 'Bearer $refreshToken',
  //         },
  //       );

  //       if (response.statusCode == 200) {
  //         final Map<String, dynamic> responseData = jsonDecode(response.body);
  //         final String newAccessToken = responseData['access_token'];
  //         final String newRefreshToken = responseData['refresh_token'];
  //         await storage.setAccessRefreshTokens(newAccessToken, newRefreshToken);
  //       } else {}
  //     } catch (e) {
  //       // print(e);
  //     }
  //   }
  // }
}
