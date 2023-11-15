// To parse this JSON data, do
//
//     final orgsData = orgsDataFromJson(jsonString);

import 'dart:convert';

OrgsData orgsDataFromJson(String str) => OrgsData.fromJson(json.decode(str));

String orgsDataToJson(OrgsData data) => json.encode(data.toJson());

class OrgsData {
  List<Datum> data;

  OrgsData({
    required this.data,
  });

  factory OrgsData.fromJson(Map<String, dynamic> json) => OrgsData(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  String nameKk;
  String nameRu;
  Email email;

  Datum({
    required this.id,
    required this.nameKk,
    required this.nameRu,
    required this.email,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        nameKk: json["name_kk"],
        nameRu: json["name_ru"],
        email: emailValues.map[json["email"]]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name_kk": nameKk,
        "name_ru": nameRu,
        "email": emailValues.reverse[email],
      };
}

enum Email { SSSSSSSSSS }

final emailValues = EnumValues({"ssssssssss": Email.SSSSSSSSSS});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}