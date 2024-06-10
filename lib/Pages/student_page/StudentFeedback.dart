import 'package:crcs/Pages/student_page/Context/student_data_context.dart';
import 'package:crcs/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    // Fetch student data when the widget initializes
    Provider.of<StudentDataContext>(context, listen: false)
        .fetchStudentData()
        .then((_) {
      // Update loading state once data is fetched
      setState(() {
        _isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching student data: $error')),
      );
    });
  }

  String? selectedTeacher;
  TextEditingController feedbackController = TextEditingController();

  String? selectedMeetingFrequency;
  List<String> meetingFrequencies = ['Yes', 'No'];

  int? selectedMeetingCount;
  List<int> meetingCounts = List.generate(10, (index) => index + 1);

  String? selectedConnectionType;
  List<String> connectionTypes = [
    'Email',
    'Phone call',
    "Physical",
    "Online meeting"
  ];

  String? selectedMeetingType;
  List<String> meetingTypes = ['One-on-One', 'Group'];

  Future<void> submitFeedback() async {
    final studentDataContext =
        Provider.of<StudentDataContext>(context, listen: false);
    final studentData = studentDataContext.studentData;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("Token");

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token not found. Please login again.')),
      );
      return;
    }

    final url = Uri.parse(postFeedBack);
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "values": {
          "mentorEmail": studentData['mentoremail'],
          "rollno": studentData['rollno'],
          "monthlyConnect": selectedMeetingFrequency,
          "monthlyCount": selectedMeetingCount,
          "meetingConnectionType": selectedConnectionType,
          "meetingType": selectedMeetingType,
          "studentFeedback": feedbackController.text,
        }
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback submitted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit feedback: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
        backgroundColor: mainColor,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: mainColor),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text("Share remarks for the meeting "),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: feedbackController,
                      decoration: const InputDecoration(
                        labelText: 'Enter Feedback',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 5,
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Did your mentor meet you in this month:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: mainColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Select Option',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedMeetingFrequency,
                      items: meetingFrequencies.map((frequency) {
                        return DropdownMenuItem<String>(
                          value: frequency,
                          child: Text(frequency),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedMeetingFrequency = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'How many times did the mentor meet you in this month:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: mainColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Select Count',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedMeetingCount,
                      items: meetingCounts.map((count) {
                        return DropdownMenuItem<int>(
                          value: count,
                          child: Text(count.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedMeetingCount = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'How did your mentor connect with you:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: mainColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Select Option',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedConnectionType,
                      items: connectionTypes.map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedConnectionType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'How did your mentor meet with you:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: mainColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Select Option',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedMeetingType,
                      items: meetingTypes.map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedMeetingType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width:
                          double.infinity, // Set the width to match the parent
                      height: 50, // Set the desired height
                      child: ElevatedButton(
                        onPressed: submitFeedback,
                        child: const Text(
                          'Submit Feedback',
                          style: TextStyle(
                            color: Colors.white, // Set the font color to white
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

const Color mainColor = Color(0xff6a6446);
const Color secondaryColor = Color(0xfff2f0e4);
const Color thirdColor = Color(0xff403a1f);
const Color fourthColor = Color(0xffbf7d2c);
