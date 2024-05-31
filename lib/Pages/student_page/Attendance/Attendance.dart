import 'dart:convert';

import 'package:crcs/Pages/student_page/Attendance/Student_attendance.dart';
import 'package:crcs/Pages/student_page/Attendance/check_in_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crcs/config.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Page'),
        backgroundColor: mainColor,
      ),
      body: Attendance(),
    );
  }
}

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  // final List<Map<String, String>> attendanceData = [];
  late List<dynamic> attendanceData;
  late double Overallatt;
  bool isLoading = false;
  bool attendance_table = false;

  // Current view state
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await fetchData();

     setState(() {
      isLoading = false;
      if (attendanceData.isNotEmpty) {
        Overallatt = calculateOverallAttendancePercentage(attendanceData);
      }
    });
  }

  Future<void> fetchData() async {
    isLoading=true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("Token");
    final rollno = prefs.getString("Rollno");

    if (token == null) {
      // Handle case where token is not found
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$getStudAtt/$rollno'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // If the server returns a successful response, parse the JSON
        Map<String, dynamic> parsedJson = jsonDecode(response.body);
        attendanceData = parsedJson['data']['att'];
        print(attendanceData);
        // prefs.setString("userData", parsedJson['data']['stu'][0]);
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
    }
  }

  double calculateOverallAttendancePercentage(List<dynamic> attendanceData) {
    int totalDays = attendanceData.length;
    int presentDays =
        attendanceData.where((item) => item['attendence'] == 'present').length;

    return totalDays > 0 ? (presentDays / totalDays) * 100 : 0;
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:isLoading ? Center(child: CircularProgressIndicator(backgroundColor:mainColor,color:mainColor)) // Show loading indicator
          : Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CardView(
            title: 'Attendance',
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudentAttendancePage()));
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
                    )),
                CheckboxButton(
                  label: 'Attendance table ',
                  isSelected: attendance_table,
                  onSelected: (value) {
                    // print(value);
                    setState(() {
                      attendance_table = value;
                    });
                    
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          if(!attendance_table)
          CardView(
            title: "Overall Attendance",
            content: Text(
              "$Overallatt%",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: (Overallatt >= 80 ? Colors.green : Colors.red[800])),
            ),
          ),

          const SizedBox(height: 16.0),
          // Attendance table (conditionally visible)
          if(attendance_table)
          CardView(
            title: 'Attendance Table',
            content: DataTable(
              columnSpacing: 24.0,
              columns: [
                const DataColumn(
                    label: Text('Week',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: thirdColor))),
                const DataColumn(
                    label: Text('Date',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: thirdColor))),
                const DataColumn(
                    label: Text('Attendance',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: thirdColor))),
              ],
              rows: attendanceData.map((data) {
                return DataRow(cells: [
                  DataCell(Text(data['week'] ?? '',
                      style: const TextStyle(color: thirdColor, fontSize: 16))),
                  DataCell(Text(data['date'] ?? '',
                      style: const TextStyle(color: thirdColor, fontSize: 16))),
                  DataCell(Text(data['attendence'] ?? '',
                      style: TextStyle(
                        color: (data['attendence'] == 'present'
                            ? Colors.green[800]
                            : Colors.red),
                        fontSize: 16,
                      ))),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class CardView extends StatelessWidget {
  final String title;
  final Widget content;

  const CardView({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: secondaryColor,
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            content,
          ],
        ),
      ),
    );
  }
}

class CheckboxButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;

  const CheckboxButton(
      {super.key,
      required this.label,
      required this.isSelected,
      required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onSelected(!isSelected);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? mainColor : thirdColor,
        foregroundColor: Colors.white,
        textStyle: TextStyle(color: isSelected ? Colors.white : Colors.white),
        minimumSize: const Size(20, 60),
      ),
      child: Text(label),
    );
  }
}

const Color mainColor = Color(0xff6a6446);
const Color secondaryColor = Color(0xfff2f0e4);
const Color thirdColor = Color(0xff403a1f);
const Color fourthColor = Color(0xffbf7d2c);
