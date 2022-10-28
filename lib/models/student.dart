import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';

Student loginResponseJson(String str) => Student.fromJson(json.decode(str));

class Student {
  Student({
    required this.id,
    required this.name,
    required this.pass,
    this.attendance,
  });
  ObjectId id;
  String name;
  String pass;
  List<String>? attendance;

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json['_id'],
        name: json['name'],
        pass: json['pass'],
        attendance: (json['attendance'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
      );

  static List<Student> parseStudentList(List<dynamic> list) {
    // if (list == null) return null;
    final studentList = <Student>[];
    for (final item in list) {
      studentList.add(Student.fromJson(item));
    }
    return studentList;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['pass'] = pass;
    data['attendance'] = attendance;
    return data;
  }
}
