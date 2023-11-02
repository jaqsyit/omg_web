// To parse this JSON data, do
//
//     final groupEditData = groupEditDataFromJson(jsonString);

import 'dart:convert';

GroupEditData groupEditDataFromJson(String str) => GroupEditData.fromJson(json.decode(str));

String groupEditDataToJson(GroupEditData data) => json.encode(data.toJson());

class GroupEditData {
    String? success;
    Group? group;
    List<Exam>? exams;

    GroupEditData({
        this.success,
        this.group,
        this.exams,
    });

    factory GroupEditData.fromJson(Map<String, dynamic> json) => GroupEditData(
        success: json["success"],
        group: json["group"] == null ? null : Group.fromJson(json["group"]),
        exams: json["exams"] == null ? [] : List<Exam>.from(json["exams"]!.map((x) => Exam.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "group": group?.toJson(),
        "exams": exams == null ? [] : List<dynamic>.from(exams!.map((x) => x.toJson())),
    };
}

class Exam {
    int? id;
    int? groupId;
    int? workerId;
    int? accessCode;
    int? pass;
    DateTime? createdAt;
    DateTime? updatedAt;

    Exam({
        this.id,
        this.groupId,
        this.workerId,
        this.accessCode,
        this.pass,
        this.createdAt,
        this.updatedAt,
    });

    factory Exam.fromJson(Map<String, dynamic> json) => Exam(
        id: json["id"],
        groupId: json["group_id"],
        workerId: json["worker_id"],
        accessCode: json["access_code"],
        pass: json["pass"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "group_id": groupId,
        "worker_id": workerId,
        "access_code": accessCode,
        "pass": pass,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class Group {
    int? userId;
    DateTime? start;
    DateTime? end;
    String? subject;
    String? chin;
    String? commission;
    int? quantity;
    int? passedOn;
    int? id;

    Group({
        this.userId,
        this.start,
        this.end,
        this.subject,
        this.chin,
        this.commission,
        this.quantity,
        this.passedOn,
        this.id,
    });

    factory Group.fromJson(Map<String, dynamic> json) => Group(
        userId: json["user_id"],
        start: json["start"] == null ? null : DateTime.parse(json["start"]),
        end: json["end"] == null ? null : DateTime.parse(json["end"]),
        subject: json["subject"],
        chin: json["chin"],
        commission: json["commission"],
        quantity: json["quantity"],
        passedOn: json["passed_on"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "start": "${start!.year.toString().padLeft(4, '0')}-${start!.month.toString().padLeft(2, '0')}-${start!.day.toString().padLeft(2, '0')}",
        "end": "${end!.year.toString().padLeft(4, '0')}-${end!.month.toString().padLeft(2, '0')}-${end!.day.toString().padLeft(2, '0')}",
        "subject": subject,
        "chin": chin,
        "commission": commission,
        "quantity": quantity,
        "passed_on": passedOn,
        "id": id,
    };
}
