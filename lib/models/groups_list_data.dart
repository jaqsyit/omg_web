// To parse this JSON data, do
//
//     final groupsListData = groupsListDataFromJson(jsonString);

import 'dart:convert';

GroupsListData groupsListDataFromJson(String str) => GroupsListData.fromJson(json.decode(str));

String groupsListDataToJson(GroupsListData data) => json.encode(data.toJson());

class GroupsListData {
    List<Datum> data;

    GroupsListData({
        required this.data,
    });

    factory GroupsListData.fromJson(Map<String, dynamic> json) => GroupsListData(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
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

    Datum({
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

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
