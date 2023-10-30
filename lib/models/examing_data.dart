// To parse this JSON data, do
//
//     final examingData = examingDataFromJson(jsonString);

import 'dart:convert';

ExamingData examingDataFromJson(String str) => ExamingData.fromJson(json.decode(str));

String examingDataToJson(ExamingData data) => json.encode(data.toJson());

class ExamingData {
    String success;
    List<Question> questions;

    ExamingData({
        required this.success,
        required this.questions,
    });

    factory ExamingData.fromJson(Map<String, dynamic> json) => ExamingData(
        success: json["success"],
        questions: List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
    };
}

class Question {
    String question;
    List<String> options;
    int correctOption;

    Question({
        required this.question,
        required this.options,
        required this.correctOption,
    });

    factory Question.fromJson(Map<String, dynamic> json) => Question(
        question: json["question"],
        options: List<String>.from(json["options"].map((x) => x)),
        correctOption: json["correct_option"],
    );

    Map<String, dynamic> toJson() => {
        "question": question,
        "options": List<dynamic>.from(options.map((x) => x)),
        "correct_option": correctOption,
    };
}
