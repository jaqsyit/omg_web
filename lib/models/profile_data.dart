// To parse this JSON data, do
//
//     final profileData = profileDataFromJson(jsonString);

import 'dart:convert';

ProfileData profileDataFromJson(String str) => ProfileData.fromJson(json.decode(str));

String profileDataToJson(ProfileData data) => json.encode(data.toJson());

class ProfileData {
    int id;
    String surname;
    String name;
    String lastname;
    String email;
    String password;
    String status;
    String rememberToken;

    ProfileData({
        required this.id,
        required this.surname,
        required this.name,
        required this.lastname,
        required this.email,
        required this.password,
        required this.status,
        required this.rememberToken,
    });

    factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        id: json["id"],
        surname: json["surname"],
        name: json["name"],
        lastname: json["lastname"],
        email: json["email"],
        password: json["password"],
        status: json["status"],
        rememberToken: json["remember_token"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "surname": surname,
        "name": name,
        "lastname": lastname,
        "email": email,
        "password": password,
        "status": status,
        "remember_token": rememberToken,
    };
}
