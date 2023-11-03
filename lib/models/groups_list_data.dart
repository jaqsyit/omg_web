// To parse this JSON data, do
//
//     final groupsListData = groupsListDataFromJson(jsonString);

import 'dart:convert';

GroupsListData groupsListDataFromJson(String str) => GroupsListData.fromJson(json.decode(str));

String groupsListDataToJson(GroupsListData data) => json.encode(data.toJson());

class GroupsListData {
    List<Datum>? data;

    GroupsListData({
        this.data,
    });

    factory GroupsListData.fromJson(Map<String, dynamic> json) => GroupsListData(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    int? userId;
    DateTime? start;
    DateTime? end;
    String? subject;
    String? chin;
    String? commission;
    int? quantity;
    int? passedOn;
    dynamic createdAt;
    dynamic updatedAt;
    List<Exam>? exam;

    Datum({
        this.id,
        this.userId,
        this.start,
        this.end,
        this.subject,
        this.chin,
        this.commission,
        this.quantity,
        this.passedOn,
        this.createdAt,
        this.updatedAt,
        this.exam,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        start: json["start"] == null ? null : DateTime.parse(json["start"]),
        end: json["end"] == null ? null : DateTime.parse(json["end"]),
        subject: json["subject"],
        chin: json["chin"],
        commission: json["commission"],
        quantity: json["quantity"],
        passedOn: json["passed_on"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        exam: json["exam"] == null ? [] : List<Exam>.from(json["exam"]!.map((x) => Exam.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "start": start?.toIso8601String(),
        "end": end?.toIso8601String(),
        "subject": subject,
        "chin": chin,
        "commission": commission,
        "quantity": quantity,
        "passed_on": passedOn,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "exam": exam == null ? [] : List<dynamic>.from(exam!.map((x) => x.toJson())),
    };
}

class Exam {
    int? id;
    int? groupId;
    int? workerId;
    int? accessCode;
    int? pass;
    dynamic createdAt;
    dynamic updatedAt;
    Workers? workers;

    Exam({
        this.id,
        this.groupId,
        this.workerId,
        this.accessCode,
        this.pass,
        this.createdAt,
        this.updatedAt,
        this.workers,
    });

    factory Exam.fromJson(Map<String, dynamic> json) => Exam(
        id: json["id"],
        groupId: json["group_id"],
        workerId: json["worker_id"],
        accessCode: json["access_code"],
        pass: json["pass"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        workers: json["workers"] == null ? null : Workers.fromJson(json["workers"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "group_id": groupId,
        "worker_id": workerId,
        "access_code": accessCode,
        "pass": pass,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "workers": workers?.toJson(),
    };
}

class Workers {
    int? id;
    String? surname;
    String? name;
    String? lastname;
    int? orgId;
    dynamic phone;
    String? job;
    int? crustId;
    Org? org;

    Workers({
        this.id,
        this.surname,
        this.name,
        this.lastname,
        this.orgId,
        this.phone,
        this.job,
        this.crustId,
        this.org,
    });

    factory Workers.fromJson(Map<String, dynamic> json) => Workers(
        id: json["id"],
        surname: json["surname"],
        name: json["name"],
        lastname: json["lastname"],
        orgId: json["org_id"],
        phone: json["phone"],
        job: json["job"],
        crustId: json["crust_id"],
        org: json["org"] == null ? null : Org.fromJson(json["org"]),
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
