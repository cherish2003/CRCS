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
  String? hrRoundQuestions;

  TextEditingController feedbackController = TextEditingController();

  List<String> companies = ['Company A', 'Company B', 'Company C', 'Company D'];
  TextEditingController round1QuestionsController = TextEditingController();
  TextEditingController technicalRound1Controller = TextEditingController();
  TextEditingController technicalRound2Controller = TextEditingController();
  TextEditingController technicalRound3Controller = TextEditingController();
  TextEditingController hrRoundQuestionsController = TextEditingController();

  List<int> technicalRounds = [1]; // Initially one technical round

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
              ...technicalRounds.map((round) {
                TextEditingController controller;
                String labelText;
                switch (round) {
                  case 1:
                    controller = technicalRound1Controller;
                    labelText = 'Technical Round 1 Questions';
                    break;
                  case 2:
                    controller = technicalRound2Controller;
                    labelText = 'Technical Round 2 Questions';
                    break;
                  case 3:
                    controller = technicalRound3Controller;
                    labelText = 'Technical Round 3 Questions';
                    break;
                  default:
                    return Container(); // Should not reach here
                }
                return Column(
                  children: [
                    Text(
                      'Questions for $labelText',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: mainColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: labelText,
                        border: OutlineInputBorder(),
                      ),
                      maxLines: null,
                    ),
                    if (round == technicalRounds.length)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (technicalRounds.length > 1)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  technicalRounds.removeLast();
                                });
                              },
                              child: Text('Remove Question'),
                            ),
                          if (technicalRounds.length < 3)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  technicalRounds
                                      .add(technicalRounds.length + 1);
                                });
                              },
                              child: Text('Add Question'),
                            ),
                        ],
                      ),
                    SizedBox(height: 16.0),
                  ],
                );
              }).toList(),
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
                        'Technical Round 1 Questions: ${technicalRound1Controller.text}');
                    if (technicalRounds.length > 1) {
                      print(
                          'Technical Round 2 Questions: ${technicalRound2Controller.text}');
                    }
                    if (technicalRounds.length > 2) {
                      print(
                          'Technical Round 3 Questions: ${technicalRound3Controller.text}');
                    }
                    print('HR Round Questions: $hrRoundQuestions');
                    // Clear input fields after submitting feedback
                    setState(() {
                      selectedCompany = null;
                      gdRound = null;
                      round1QuestionsController.clear();
                      technicalRound1Controller.clear();
                      if (technicalRounds.length > 1) {
                        technicalRound2Controller.clear();
                      }
                      if (technicalRounds.length > 2) {
                        technicalRound3Controller.clear();
                      }
                      hrRoundQuestionsController.clear();
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
