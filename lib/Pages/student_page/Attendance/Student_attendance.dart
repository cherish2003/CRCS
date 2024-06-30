import 'dart:async';

import 'package:crcs/Pages/student_page/Attendance/StudAttQrscanner.dart';

import 'package:crcs/Pages/student_page/Attendance/check_in_service.dart';
import 'package:crcs/components/checkmark.dart';
import 'package:flutter/material.dart';

class StudentAttendancePage extends StatefulWidget {
  const StudentAttendancePage({Key? key}) : super(key: key);

  @override
  _StudentAttendancePageState createState() => _StudentAttendancePageState();
}

class _StudentAttendancePageState extends State<StudentAttendancePage> {
  int flag = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Page",
            style: TextStyle(color: Colors.white)),
        backgroundColor: mainColor,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (flag == 0)
              Column(
                children: [
                  const SizedBox(height: 10),
                  const Text("Select attendance type",
                      style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CheckInWidget()));
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: mainColor,
                      minimumSize: const Size(100, 60),
                      maximumSize: const Size(180, 120),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person, size: 25, color: Colors.white),
                        const SizedBox(height: 10),
                        Text("Your QR", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QRScannerScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: mainColor,
                      minimumSize: const Size(100, 60),
                      maximumSize: const Size(180, 120),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.qr_code_scanner_rounded,
                            size: 26, color: Colors.white),
                        const SizedBox(width: 10),
                        Text("Scanner", style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ],
              )
            else if (flag == 1)
              GestureDetector(
                onTap: () {
                  setState(() {
                    flag = 3;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: thirdColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            )
                          ],
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(72),
                        ),
                        child: const Icon(Icons.bluetooth,
                            size: 84, color: Colors.white),
                      ),
                      const Text(
                        "Tap to mark attendance",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              )
            else if (flag == 2)
              Center(
                child: Column(
                  children: [
                    const CheckMarkPage(),
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Attendance recorded!",
                            style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            flag = 0;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              const Color.fromARGB(255, 103, 58, 183),
                          minimumSize: const Size(100, 60),
                          maximumSize: const Size(150, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        child: const Row(
                          children: [
                            SizedBox(width: 8),
                            Icon(Icons.logout, size: 26, color: Colors.white),
                            SizedBox(width: 10),
                            Text("Back", style: TextStyle(fontSize: 18)),
                          ],
                        )),
                  ],
                ),
              )
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
