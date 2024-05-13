import 'package:flutter/material.dart';

class CompanyFeedback extends StatefulWidget {
  const CompanyFeedback({super.key});

  @override
  _CompanyFeedbackState createState() => _CompanyFeedbackState();
}


class _CompanyFeedbackState extends State<CompanyFeedback> {
  String? selectedCompany;
  bool? gdRound;
  String? round1Questions;
  String? technicalRoundQuestions;
  String? hrRoundQuestions;

  TextEditingController feedbackController = TextEditingController();

  List<String> companies = ['Company A', 'Company B', 'Company C', 'Company D'];
  TextEditingController round1QuestionsController = TextEditingController();
  TextEditingController technicalRoundQuestionsController =
      TextEditingController();
  TextEditingController hrRoundQuestionsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Company Feedback'),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Company Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: mainColor,
                ),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
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
              SizedBox(height: 16.0),
              Text(
                'Pattern of Drive',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: mainColor,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Rounds in the Drive',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  // Handle changes in the number of rounds
                },
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text('GD Round:'),
                  SizedBox(width: 8),
                  Row(
                    children: [
                      Text('Yes'),
                      Radio<bool>(
                        value: true,
                        groupValue: gdRound,
                        onChanged: (value) {
                          setState(() {
                            gdRound = value;
                          });
                        },
                      ),
                      Text('No'),
                      Radio<bool>(
                        value: false,
                        groupValue: gdRound,
                        onChanged: (value) {
                          setState(() {
                            gdRound = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text(
                'Questions for Round 1',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: mainColor,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: round1QuestionsController,
                decoration: InputDecoration(
                  labelText: 'Round 1 Questions',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
              ),
              SizedBox(height: 16.0),
              Text(
                'Questions for Technical Round',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: mainColor,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: technicalRoundQuestionsController,
                decoration: InputDecoration(
                  labelText: 'Technical Round Questions',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
              ),
              SizedBox(height: 16.0),
              Text(
                'Questions for HR Round',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: mainColor,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: hrRoundQuestionsController,
                decoration: InputDecoration(
                  labelText: 'HR Round Questions',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
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
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Add logic to submit feedback
                    print('Selected Company: $selectedCompany');
                    print('GD Round: $gdRound');
                    print('Round 1 Questions: $round1Questions');
                    print(
                        'Technical Round Questions: $technicalRoundQuestions');
                    print('HR Round Questions: $hrRoundQuestions');
                    print('Feedback: ${feedbackController.text}');
                    // Clear input fields after submitting feedback
                    setState(() {
                      selectedCompany = null;
                      gdRound = null;
                      round1QuestionsController.clear();
                      technicalRoundQuestionsController.clear();
                      hrRoundQuestionsController.clear();
                      feedbackController.clear();
                    });
                  },
                  child: Text(
                    'Submit Feedback',
                    style: TextStyle(
                      color: Colors.white,
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
