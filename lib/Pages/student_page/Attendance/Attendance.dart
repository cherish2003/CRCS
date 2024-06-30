import 'dart:convert';

import 'package:crcs/Pages/student_page/Attendance/EventsAtt.dart';
import 'package:crcs/Pages/student_page/Attendance/Student_attendance.dart';
import 'package:crcs/Pages/student_page/Attendance/check_in_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crcs/api/config.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class Attendance extends StatelessWidget {
  const Attendance({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20), // Space below the line
                  const Text(
                      "For taking current session attendance click on Take attendance button ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: thirdColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      )),
                  const SizedBox(height: 16),
                  const Text(
                      "if want to check your attendance details and attented days and overall attendance click on the Attendance Events button",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: thirdColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      )),
                  const SizedBox(height: 20), // Space below the text

                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentAttendancePage(),
                        ),
                      );
                    },
                    icon: Icon(Icons.mark_chat_read),
                    label: Text(
                      "Take attendance",
                      style: TextStyle(fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(20, 60),
                      backgroundColor: thirdColor,
                      foregroundColor: secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 60), // Space between buttons
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventAtt(),
                        ),
                      );
                    },
                    icon: Icon(Icons.event_available),
                    label: Text(
                      "Attendance events ",
                      style: TextStyle(fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(20, 60),
                      backgroundColor: thirdColor,
                      foregroundColor: secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardView extends StatelessWidget {
  final String title;
  final Widget content;

  const CardView({Key? key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: secondaryColor,
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: content,
            ),
          ],
        ),
      ),
    );
  }
}

const Color mainColor = Color(0xff6a6446);
const Color secondaryColor = Color(0xfff2f0e4);
const Color thirdColor = Color(0xff403a1f);
const Color fourthColor = Color(0xffbf7d2c);
