import 'package:flutter/material.dart';

// Define the model class
class UserData {
  final String id;
  final int sno;
  final String name;
  final String rollNo;
  final String phone;
  final String parentPhone;
  final String email;
  final String mentor;
  final String mentorEmail;
  final String branch;
  final String course;
  final String batch;
  final int v;

  UserData({
    required this.id,
    required this.sno,
    required this.name,
    required this.rollNo,
    required this.phone,
    required this.parentPhone,
    required this.email,
    required this.mentor,
    required this.mentorEmail,
    required this.branch,
    required this.course,
    required this.batch,
    required this.v,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'],
      sno: json['sno'],
      name: json['name'],
      rollNo: json['rollno'],
      phone: json['phone'],
      parentPhone: json['parentphone'],
      email: json['email'],
      mentor: json['mentor'],
      mentorEmail: json['mentoremail'],
      branch: json['branch'],
      course: json['course'],
      batch: json['batch'],
      v: json['__v'],
    );
  }
}

// Define the provider class
class UserDataProvider extends ChangeNotifier {
  UserData? _userData;

  void setUserData(UserData userData) {
    _userData = userData;
    notifyListeners();
  }

  UserData? get userData => _userData;
}
