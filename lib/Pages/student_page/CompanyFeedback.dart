import 'package:flutter/material.dart';

class CompanyFeedback extends StatefulWidget {
  const CompanyFeedback({super.key});

  @override
  _CompanyFeedbackState createState() => _CompanyFeedbackState();
}

class _CompanyFeedbackState extends State<CompanyFeedback> {
  String? selectedCompany;
  String? selectedInterviewFeedback;
  List<String> companies = ['Company A', 'Company B', 'Company C', 'Company D'];
  List<String> interviewFeedbackOptions = ['Hard', 'Easy', 'Not Useful'];

  TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Feedback'),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Select Company',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: mainColor,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select Company',
                  border: OutlineInputBorder(),
                ),
                value: selectedCompany,
                items: companies.map((company) {
                  return DropdownMenuItem<String>(
                    value: company,
                    child: Text(company),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCompany = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Interview Feedback',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: mainColor,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Interview Feedback',
                  border: OutlineInputBorder(),
                ),
                value: selectedInterviewFeedback,
                items: interviewFeedbackOptions.map((feedback) {
                  return DropdownMenuItem<String>(
                    value: feedback,
                    child: Text(feedback),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedInterviewFeedback = value;
                  });
                },
              ),
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
              SizedBox(
                width: double.infinity, // Set the width to match the parent
                height: 50, // Set the desired height
                child: ElevatedButton(
                  onPressed: () {
                    // Add logic to submit feedback
                    print('Selected Company: $selectedCompany');
                    print('Interview Feedback: $selectedInterviewFeedback');
                    print('Feedback: ${feedbackController.text}');
                    // Clear input fields after submitting feedback
                    setState(() {
                      selectedCompany = null;
                      selectedInterviewFeedback = null;
                      feedbackController.clear();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                  ),
                  child: const Text(
                    'Submit Feedback',
                    style: TextStyle(
                      color: Colors.white,
                    ),
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
