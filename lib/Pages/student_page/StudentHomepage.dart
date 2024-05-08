import 'package:flutter/material.dart';

class StudentHomepage extends StatelessWidget {
  const StudentHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: mainColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          CardView(
            title: 'Weekly Attendance',
            content:
                'Students you may refer to the detailed attendance for further clarifications on above consolidated attendance, we have not considered Barclays attendance for computing weekly attendance. Also students are marked as "present" only if they have spent minimum of 80% time in the session Students who have not met 80% in weekly attendance will not be allowed into placement process.',
            color: secondaryColor,
          ),
          SizedBox(height: 16.0),
          CardView(
            title: 'Announcements',
            content:
                'Announcement\n\nStudents should attend all the training program organised by the University, attendance will be viewed seriously\n\n.',
            color: secondaryColor,
          ),
        ],
      ),
    );
  }
}

class CardView extends StatelessWidget {
  final String title;
  final String content;
  final Color color;

  const CardView(
      {super.key,
      required this.title,
      required this.content,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: fourthColor,
              ),
            ),
            const SizedBox(height: 16.0),
            content.startsWith('Announcement')
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: thirdColor,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        'Your Skill Level',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: thirdColor,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      const Divider(color: thirdColor),
                      InkWell(
                        onTap: () {
                          // Handle click action for "Above 90"
                        },
                        child: const ListTile(
                          title: Text(
                            'Above 90',
                            style: TextStyle(color: thirdColor),
                          ),
                          subtitle: Text(
                            'Excellent',
                            style: TextStyle(color: thirdColor),
                          ),
                        ),
                      ),
                      const Divider(color: thirdColor),
                      InkWell(
                        onTap: () {
                          // Handle click action for "Above 80"
                        },
                        child: const ListTile(
                          title: Text(
                            'Above 80',
                            style: TextStyle(color: thirdColor),
                          ),
                          subtitle: Text(
                            'Very good',
                            style: TextStyle(color: thirdColor),
                          ),
                        ),
                      ),
                      const Divider(color: thirdColor),
                      InkWell(
                        onTap: () {
                          // Handle click action for "Above 70"
                        },
                        child: const ListTile(
                          title: Text(
                            'Above 70',
                            style: TextStyle(color: thirdColor),
                          ),
                          subtitle: Text(
                            'Good',
                            style: TextStyle(color: thirdColor),
                          ),
                        ),
                      ),
                      const Divider(color: thirdColor),
                      InkWell(
                        onTap: () {
                          // Handle click action for "Above 60"
                        },
                        child: const ListTile(
                          title: Text(
                            'Above 60',
                            style: TextStyle(color: thirdColor),
                          ),
                          subtitle: Text(
                            'Average',
                            style: TextStyle(color: thirdColor),
                          ),
                        ),
                      ),
                    ],
                  )
                : Text(
                    content,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: thirdColor,
                    ),
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
