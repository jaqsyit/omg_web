import 'dart:convert';

import 'package:http/http.dart';

class JsonDecoder {
  Map<String, dynamic> responseToMap(Response response) {
    final utfDecoded = utf8.decode(response.bodyBytes);
    final decodedJson = jsonDecode(utfDecoded);
    final Map<String, dynamic> answerMap = decodedJson;

    return answerMap;
  }
}