import 'dart:convert';
import 'package:crcs/Pages/FacultyCoor/Attendance%20/FacultyQrGen.dart';
import 'package:crcs/Pages/FacultyCoor/Attendance%20/FacultyQrScanner.dart';
import 'package:flutter/material.dart';
import 'package:crcs/api/config.dart';
import 'FacultyCoorSessions.dart';
import 'package:crcs/Pages/student_page/Attendance/check_in_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EventDetails extends StatefulWidget {
  final Event event;

  const EventDetails({required this.event, super.key});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  bool isLoading = false;
  bool attendanceTable = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.name),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: mainColor,
                  color: mainColor,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CardView(
                    title: 'Event details',
                    content: Column(
                      children: [
                        Text(
                          'Name :${widget.event.name}',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: fourthColor,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Date: ${widget.event.date}',
                          style: TextStyle(fontSize: 16.0, color: thirdColor),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Duration: ${widget.event.duration.inHours} hours',
                          style: TextStyle(fontSize: 16.0, color: thirdColor),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Description: ${widget.event.description}',
                          style: TextStyle(fontSize: 16.0, color: thirdColor),
                        ),
                        SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  CardView(
                      title: "Attendance method ",
                      content: Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  "Select the attendance method for this session",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400)),
                              const SizedBox(height: 23),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Facultyqrscanner(
                                              eventId: widget.event.id,
                                            ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: mainColor,
                                    minimumSize: const Size(150, 60),
                                    maximumSize: const Size(150, 60),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32.0),
                                    ),
                                  ),
                                  child: Text("Student Scan",
                                      style: TextStyle(fontSize: 16))),
                              const SizedBox(height: 23),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FacultyQrgen(
                                              eventId: widget.event.id,
                                            )),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: mainColor,
                                  minimumSize: const Size(100, 60),
                                  maximumSize: const Size(150, 60),
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
                                    Text("QR", style: TextStyle(fontSize: 18)),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ))
                ],
              ),
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
