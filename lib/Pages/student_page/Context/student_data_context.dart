import 'package:crcs/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudentDataContext extends ChangeNotifier {
  Map<String, dynamic> _studentData = {};

  Map<String, dynamic> get studentData => _studentData;

  Future<void> fetchStudentData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("Token");

    if (token == null) {
      // Handle case where token is not found
      return;
    }

    final url = Uri.parse(
        getStudinfo); // Replace with your actual URL
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If the server returns a successful response, parse the JSON
      Map<String, dynamic> parsedJson = jsonDecode(response.body);
      _studentData = parsedJson['data']['stu'][0];
      notifyListeners(); // Notify listeners to rebuild UI
    } else {
      // Handle error
      throw Exception('Failed to load data');
    }
  }
}
