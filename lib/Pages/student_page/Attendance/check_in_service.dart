import 'package:crcs/Pages/student_page/Attendance/Student_attendance.dart';
import 'package:crcs/components/checkmark.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CheckInWidget extends StatefulWidget {
  @override
  _CheckInWidgetState createState() => _CheckInWidgetState();
}

class _CheckInWidgetState extends State<CheckInWidget> {
  int flag = 0;
  late Future<String> _rollnoFuture;

  @override
  void initState() {
    super.initState();
    _rollnoFuture = _getRollNumber();
  }

  Future<String> _getRollNumber() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("Rollno") ?? 'Unknown Rollno';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Attendance : Auditorium",
              style: TextStyle(color: Colors.white)),
          backgroundColor: mainColor),
      body: Center(
        child: FutureBuilder<String>(
          future: _rollnoFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final rollno = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    if (flag == 0)
                      Card(
                        child: QrImageView(
                          data: rollno,
                          version: QrVersions.auto,
                          size: 350.0,
                          backgroundColor: secondaryColor,
                        ),
                      ),
                    if (flag == 0)
                      Container(
                        margin: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Note: \n1. Show the QR to the mentor once scanned your attendance will be reflected in the below card within few seconds \n\n2. Once mentor captures the attendance then go to attendace events and check in there to wheather your attendance is updated or not !! ",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (flag == 1)
                      Container(
                          margin: const EdgeInsets.all(16.0),
                          child: CardView(
                              title: "Today Attendance Status",
                              content: Column(
                                children: [Text("dasdas")],
                              )))
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class CardView extends StatelessWidget {
  final String title;
  final Widget content;

  const CardView({Key? key, required this.title, required this.content})
      : super(key: key);

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

const Color mainColor = Color(0xff6a6446);
const Color secondaryColor = Color(0xfff2f0e4);
const Color thirdColor = Color(0xff403a1f);
const Color fourthColor = Color(0xffbf7d2c);
