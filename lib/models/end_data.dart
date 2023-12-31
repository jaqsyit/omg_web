// To parse this JSON data, do
//
//     final endData = endDataFromJson(jsonString);

import 'dart:convert';

EndData endDataFromJson(String str) => EndData.fromJson(json.decode(str));

String endDataToJson(EndData data) => json.encode(data.toJson());

class EndData {
    String success;
    Questions questions;

    EndData({
        required this.success,
        required this.questions,
    });

    factory EndData.fromJson(Map<String, dynamic> json) => EndData(
        success: json["success"],
        questions: Questions.fromJson(json["questions"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "questions": questions.toJson(),
    };
}

class Questions {
    int id;
    int groupId;
    int workerId;
    int accessCode;
    int pass;
    DateTime createdAt;
    DateTime updatedAt;
    Group group;
    Workers workers;

    Questions({
        required this.id,
        required this.groupId,
        required this.workerId,
        required this.accessCode,
        required this.pass,
        required this.createdAt,
        required this.updatedAt,
        required this.group,
        required this.workers,
    });

    factory Questions.fromJson(Map<String, dynamic> json) => Questions(
        id: json["id"],
        groupId: json["group_id"],
        workerId: json["worker_id"],
        accessCode: json["access_code"],
        pass: json["pass"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        group: Group.fromJson(json["group"]),
        workers: Workers.fromJson(json["workers"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "group_id": groupId,
        "worker_id": workerId,
        "access_code": accessCode,
        "pass": pass,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "group": group.toJson(),
        "workers": workers.toJson(),
    };
}

class Group {
    int id;
    int userId;
    DateTime start;
    DateTime end;
    String subject;
    String chin;
    String commission;
    int quantity;
    int passedOn;
    dynamic createdAt;
    dynamic updatedAt;

    Group({
        required this.id,
        required this.userId,
        required this.start,
        required this.end,
        required this.subject,
        required this.chin,
        required this.commission,
        required this.quantity,
        required this.passedOn,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Group.fromJson(Map<String, dynamic> json) => Group(
        id: json["id"],
        userId: json["user_id"],
        start: DateTime.parse(json["start"]),
        end: DateTime.parse(json["end"]),
        subject: json["subject"],
        chin: json["chin"],
        commission: json["commission"],
        quantity: json["quantity"],
        passedOn: json["passed_on"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "start": start.toIso8601String(),
        "end": end.toIso8601String(),
        "subject": subject,
        "chin": chin,
        "commission": commission,
        "quantity": quantity,
        "passed_on": passedOn,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}

class Workers {
    int id;
    String surname;
    String name;
    String lastname;
    int orgId;
    dynamic phone;
    String job;
    int crustId;
    Org org;

    Workers({
        required this.id,
        required this.surname,
        required this.name,
        required this.lastname,
        required this.orgId,
        required this.phone,
        required this.job,
        required this.crustId,
        required this.org,
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
        org: Org.fromJson(json["org"]),
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
        "org": org.toJson(),
    };
}

class Org {
    int id;
    String nameKk;
    String nameRu;
    String email;

    Org({
        required this.id,
        required this.nameKk,
        required this.nameRu,
        required this.email,
    });

    factory Org.fromJson(Map<String, dynamic> json) => Org(
        id: json["id"],
        nameKk: json["name_kk"],
        nameRu: json["name_ru"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name_kk": nameKk,
        "name_ru": nameRu,
        "email": email,
    };
}
