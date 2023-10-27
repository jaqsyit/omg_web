// To parse this JSON data, do
//
//     final loginData = loginDataFromJson(jsonString);

import 'dart:convert';

LoginData loginDataFromJson(String str) => LoginData.fromJson(json.decode(str));

String loginDataToJson(LoginData data) => json.encode(data.toJson());

class LoginData {
    String token;
    Profile profile;

    LoginData({
        required this.token,
        required this.profile,
    });

    factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        token: json["token"],
        profile: Profile.fromJson(json["profile"]),
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "profile": profile.toJson(),
    };
}

class Profile {
    int id;
    String surname;
    String name;
    String lastname;
    String email;
    String password;
    String status;

    Profile({
        required this.id,
        required this.surname,
        required this.name,
        required this.lastname,
        required this.email,
        required this.password,
        required this.status,
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
