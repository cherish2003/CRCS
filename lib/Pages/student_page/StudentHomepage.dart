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
        children: [
          CardView(
            title: 'Announcements',
            content:
                'Announcement\n\nStudents should attend all the training program organised by the University, attendance will be viewed seriously\n\n.',
            color: secondaryColor,
          ),
          SizedBox(height: 16.0),
          Card(
            color: secondaryColor,
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Eligible Companies',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: fourthColor,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  CompanyTile(
                    companyName: 'Company A',
                    type: 'Super Dream',
                    expectedDate: 'June 10, 2024',
                  ),
                  Divider(), // Line break
                  CompanyTile(
                    companyName: 'Company B',
                    type: 'Core Dream',
                    expectedDate: 'June 15, 2024',
                  ),
                  Divider(), // Line break
                  CompanyTile(
                    companyName: 'Company C',
                    type: 'Dream',
                    expectedDate: 'June 20, 2024',
                  ),
                  Divider(), // Line break
                  CompanyTile(
                    companyName: 'Company D',
                    type: 'Core',
                    expectedDate: 'June 25, 2024',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CompanyTile extends StatelessWidget {
  final String companyName;
  final String type;
  final String expectedDate;

  const CompanyTile({
    required this.companyName,
    required this.type,
    required this.expectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(companyName),
      subtitle: Text('Type: $type\nExpected Date: $expectedDate'),
      onTap: () {
        // Handle tile tap
      },
    );
  }
}

class CardView extends StatelessWidget {
  final String title;
  final String content;
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
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: fourthColor,
              ),
            ),
            const SizedBox(height: 16.0),
            content.startsWith('Announcement')
                ? Text(
                    content,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: thirdColor,
                    ),
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
