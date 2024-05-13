import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}


class _FeedbackScreenState extends State<FeedbackScreen> {
  String? selectedTeacher;
  List<String> teachers = ['Murali', 'Krishna', 'Akhila', 'Cherish Laxman'];

  TextEditingController feedbackController = TextEditingController();

  String? selectedMeetingFrequency;
  List<String> meetingFrequencies = ['Yes', 'No'];

  int? selectedMeetingCount;
  List<int> meetingCounts = List.generate(10, (index) => index + 1);

  String? selectedConnectionType;
  List<String> connectionTypes = ['In-person', 'Online'];

  String? selectedMeetingType;
  List<String> meetingTypes = ['One-on-One', 'Group'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Select Teacher',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: mainColor,
                ),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Teacher',
                  border: OutlineInputBorder(),
                ),
                value: selectedTeacher,
                items: teachers.map((teacher) {
                  return DropdownMenuItem<String>(
                    value: teacher,
                    child: Text(teacher),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTeacher = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: feedbackController,
                decoration: InputDecoration(
                  labelText: 'Enter Feedback',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              SizedBox(height: 16.0),
              Text(
                'Did your mentor meet you in this month:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: mainColor,
                ),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
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
              SizedBox(height: 16.0),
              Text(
                'How many times did the mentor meet you in this month:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: mainColor,
                ),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
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
              SizedBox(height: 16.0),
              Text(
                'How did your mentor connect with you:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: mainColor,
                ),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
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
              SizedBox(height: 16.0),
              Text(
                'How did your mentor meet with you:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: mainColor,
                ),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
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
              SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity, // Set the width to match the parent
                height: 50, // Set the desired height
                child: ElevatedButton(
                  onPressed: () {
                    // Add logic to submit feedback
                    print('Selected Teacher: $selectedTeacher');
                    print('Feedback: ${feedbackController.text}');
                    print('Meeting Frequency: $selectedMeetingFrequency');
                    print('Meeting Count: $selectedMeetingCount');
                    print('Connection Type: $selectedConnectionType');
                    print('Meeting Type: $selectedMeetingType');
                    // Clear input fields after submitting feedback
                    setState(() {
                      selectedTeacher = null;
                      feedbackController.clear();
                      selectedMeetingFrequency = null;
                      selectedMeetingCount = null;
                      selectedConnectionType = null;
                      selectedMeetingType = null;
                    });
                  },
                  child: Text(
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
