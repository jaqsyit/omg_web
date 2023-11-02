// To parse this JSON data, do
//
//     final changePassData = changePassDataFromJson(jsonString);

import 'dart:convert';

ChangePassData changePassDataFromJson(String str) => ChangePassData.fromJson(json.decode(str));

String changePassDataToJson(ChangePassData data) => json.encode(data.toJson());

class ChangePassData {
    String? message;
    Profile? profile;

    ChangePassData({
        this.message,
        this.profile,
    });

    factory ChangePassData.fromJson(Map<String, dynamic> json) => ChangePassData(
        message: json["message"],
        profile: json["profile"] == null ? null : Profile.fromJson(json["profile"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "profile": profile?.toJson(),
    };
}

class Profile {
    int? id;
    String? surname;
    String? name;
    String? lastname;
    String? email;
    String? password;
    String? status;

    Profile({
        this.id,
        this.surname,
        this.name,
        this.lastname,
        this.email,
        this.password,
        this.status,
    });

    factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        surname: json["surname"],
        name: json["name"],
        lastname: json["lastname"],
        email: json["email"],
        password: json["password"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "surname": surname,
        "name": name,
        "lastname": lastname,
        "email": email,
        "password": password,
        "status": status,
    };
}
