import 'package:flutter/material.dart';

class ContactAndSupportScreen extends StatelessWidget {
  const ContactAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact and Support'),
        backgroundColor: mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            CardView(
              title: 'Contact Information',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email: crcs.helpdesk@srmap.edu.in',
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

  const CardView({super.key, 
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
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: fourthColor,
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
