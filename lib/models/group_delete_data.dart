// To parse this JSON data, do
//
//     final groupDeleteData = groupDeleteDataFromJson(jsonString);

import 'dart:convert';

GroupDeleteData groupDeleteDataFromJson(String str) => GroupDeleteData.fromJson(json.decode(str));

String groupDeleteDataToJson(GroupDeleteData data) => json.encode(data.toJson());

class GroupDeleteData {
    String? success;
    Group? group;

    GroupDeleteData({
        this.success,
        this.group,
    });

    factory GroupDeleteData.fromJson(Map<String, dynamic> json) => GroupDeleteData(
        success: json["success"],
        group: json["group"] == null ? null : Group.fromJson(json["group"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "group": group?.toJson(),
    };
}

class Group {
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

    Group({
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
    });

    factory Group.fromJson(Map<String, dynamic> json) => Group(
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
    };
}
