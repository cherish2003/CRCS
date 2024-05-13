import 'package:flutter/material.dart';

class ContactAndSupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Placement Policy'),
        backgroundColor: mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CardView(
              title: 'Contact and Policy',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Please note: Students are encouraged to consult the detailed attendance records for additional clarification on the consolidated attendance mentioned above. Moreover, students should only be marked as "present" if they have devoted a minimum of 80% of the session\'s duration to participation. This especially applies to students who have been involved in placement processes.',
                    style: TextStyle(fontSize: 16, color: thirdColor),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Phone: 122-344-5555',
                    style: TextStyle(fontSize: 16, color: thirdColor),
                  ),
                ],
              ),
              color: secondaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class CardView extends StatelessWidget {
  final String title;
  final Widget content;
  final Color color;

  const CardView({
    required this.title,
    required this.content,
    required this.color,
  });

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
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: fourthColor,
              ),
            ),
            SizedBox(height: 16.0),
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
