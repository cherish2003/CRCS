import 'package:flutter/material.dart';
import 'package:crcs/Pages/student_page/StudCompanies.dart';

class Studcompanydetails extends StatelessWidget {
  final Event event;
  final bool isShortlisted;
  final bool isPlaced;
  final bool isApplied;
  final bool isEligible;

  const Studcompanydetails({
    required this.event,
    required this.isShortlisted,
    required this.isPlaced,
    required this.isApplied,
    required this.isEligible,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
        backgroundColor: mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardView(
              title: 'Company Info',
              content: Text(
                'The entire info of the company will be shown here.',
                style: TextStyle(fontSize: 16),
              ),
              color: secondaryColor,
            ),
            // Company Details Card
            CardView(
              title: 'Company Details',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Company Name: ${event.name}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('CTC: ${event.CTC} LPA', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Job Role: ${event.jobRole}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Job Location: ${event.jobLoc}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Date of Visit: ${event.dateOfVisit}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Branches: ${event.branches}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Drive Status: ${event.driveStatus}',
                      style: TextStyle(fontSize: 16)),
                ],
              ),
              color: secondaryColor,
            ),
            SizedBox(height: 16),
            // Status Chips
            CardView(
              title: 'Status',
              content: Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: [
                  if (isShortlisted)
                    Chip(
                      avatar: Icon(Icons.check_circle, color: Colors.white),
                      label: Text('Shortlisted',
                          style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.blue,
                    ),
                  if (isPlaced)
                    Chip(
                      avatar: Icon(Icons.done_all, color: Colors.white),
                      label:
                          Text('Placed', style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.green,
                    ),
                  if (isApplied)
                    Chip(
                      avatar: Icon(Icons.event_available, color: Colors.white),
                      label: Text('Applied',
                          style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.orange,
                    ),
                  if (isEligible)
                    Chip(
                      avatar: Icon(Icons.star, color: Colors.white),
                      label: Text('Eligible',
                          style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.purple,
                    ),
                  if (!isShortlisted && !isPlaced && !isApplied && !isEligible)
                    Chip(
                      avatar: Icon(Icons.not_interested_outlined,
                          color: Colors.white),
                      label: Text('Not applied',
                          style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.red,
                    )
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
    Key? key,
  }) : super(key: key);

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
