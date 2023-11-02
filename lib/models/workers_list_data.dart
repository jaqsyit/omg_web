// To parse this JSON data, do
//
//     final workersListData = workersListDataFromJson(jsonString);

import 'dart:convert';

WorkersListData workersListDataFromJson(String str) => WorkersListData.fromJson(json.decode(str));

String workersListDataToJson(WorkersListData data) => json.encode(data.toJson());

class WorkersListData {
    List<Datum>? data;

    WorkersListData({
        this.data,
    });

    factory WorkersListData.fromJson(Map<String, dynamic> json) => WorkersListData(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    String? surname;
    String? name;
    String? lastname;
    int? orgId;
    dynamic phone;
    String? job;
    int? crustId;
    Org? org;
    Crust? crust;

    Datum({
        this.id,
        this.surname,
        this.name,
        this.lastname,
        this.orgId,
        this.phone,
        this.job,
        this.crustId,
        this.org,
        this.crust,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        surname: json["surname"],
        name: json["name"],
        lastname: json["lastname"],
        orgId: json["org_id"],
        phone: json["phone"],
        job: json["job"],
        crustId: json["crust_id"],
        org: json["org"] == null ? null : Org.fromJson(json["org"]),
        crust: json["crust"] == null ? null : Crust.fromJson(json["crust"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "surname": surname,
        "name": name,
        "lastname": lastname,
        "org_id": orgId,
        "phone": phone,
        "job": job,
        "crust_id": crustId,
        "org": org?.toJson(),
        "crust": crust?.toJson(),
    };
}

class Crust {
    int? id;
    int? userId;
    dynamic createdAt;
    dynamic updatedAt;

    Crust({
        this.id,
        this.userId,
        this.createdAt,
        this.updatedAt,
    });

    factory Crust.fromJson(Map<String, dynamic> json) => Crust(
        id: json["id"],
        userId: json["user_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}

class Org {
    int? id;
    String? nameKk;
    String? nameRu;
    Email? email;

    Org({
        this.id,
        this.nameKk,
        this.nameRu,
        this.email,
    });

    factory Org.fromJson(Map<String, dynamic> json) => Org(
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

enum Email {
    SSSSSSSSSS
}

final emailValues = EnumValues({
    "ssssssssss": Email.SSSSSSSSSS
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
