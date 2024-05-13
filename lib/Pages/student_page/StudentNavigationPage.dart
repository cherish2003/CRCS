import 'package:crcs/Pages/student_page/Attendance/Attendance.dart';
import 'package:crcs/Pages/student_page/Events.dart';
import 'package:crcs/Pages/student_page/Studentinfo.dart';
import 'package:crcs/Pages/student_page/mypratice.dart';
import 'package:crcs/Pages/student_page/performance.dart';
import 'package:flutter/material.dart';
import 'package:crcs/Pages/student_page/CompanyFeedback.dart';
import 'package:crcs/Pages/student_page/ContactSupport.dart';
import 'package:crcs/Pages/student_page/Studentinfo.dart';
import 'package:crcs/Pages/student_page/Settings.dart';
import 'package:crcs/Pages/student_page/StudentFeedback.dart';
import 'package:crcs/Pages/student_page/StudentHomepage.dart';

class StudentNavigationPage extends StatelessWidget {
  const StudentNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRCS'),
        backgroundColor: mainColor,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            color: Colors.black,
            icon: const Icon(Icons.logout),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 100,
              // Adjust the height as needed
              decoration: const BoxDecoration(
                color: mainColor,
              ),
              child: Center(
                child: Image.asset(
                  'images/BLogo.png', // Replace 'your_image.png' with your image asset path
                  width: 70,
                  height: 70, // Adjust width as needed
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const StudentHomepage()),
                );
              },
              hoverColor: thirdColor.withOpacity(0.5),
            ),
            ListTile(
              title: const Text('Attendance'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AttendancePage()),
                );
              },
              hoverColor: thirdColor.withOpacity(0.5),
            ),
            ListTile(
              title: const Text('Events'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventPage()),
                );
              },
              hoverColor: thirdColor.withOpacity(0.5),
            ),
            ListTile(
              title: const Text('Practice'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPracticeScreen()),
                );
              },
              hoverColor: thirdColor.withOpacity(0.5),
            ),
            ListTile(
              title: const Text('Student info'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CardExample()),
                );
              },
              hoverColor: thirdColor.withOpacity(0.5),
            ),
            ListTile(
              title: const Text('My Performance'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PerformanceScreen()),
                );
              },
              hoverColor: thirdColor.withOpacity(0.5),
            ),
            ListTile(
              title: const Text('Student feedback to mentor'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FeedbackScreen()),
                );
              },
              hoverColor: thirdColor.withOpacity(0.5),
            ),
            ListTile(
              title: const Text('Company Feedback'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CompanyFeedback()),
                );
              },
              hoverColor: thirdColor.withOpacity(0.5),
            ),
            ListTile(
              title: const Text('Placement Policy'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ContactAndSupportScreen()),
                );
              },
              hoverColor: thirdColor.withOpacity(0.5),
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
              },
              hoverColor: thirdColor.withOpacity(0.5),
            ),
          ],
        ),
      ),
      body: Container(
        color: secondaryColor,
        child: const MotivationalQuoteCard(),
      ),
    );
  }
}

class MotivationalQuoteCard extends StatelessWidget {
  const MotivationalQuoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      color: secondaryColor,
      elevation: 4.0,
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Motivational Quote',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: fourthColor,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '"You are braver than you believe, stronger than you seem, and smarter than you think."',
              style: TextStyle(fontSize: 16, color: thirdColor),
            ),
            SizedBox(height: 8),
            Text(
              'Remember, your hard work will pay off!',
              style: TextStyle(fontSize: 16, color: thirdColor),
            ),
            SizedBox(height: 8),
            Text(
              'Placements are crucial for your future. Stay motivated!',
              style: TextStyle(fontSize: 16, color: thirdColor),
            ),
            SizedBox(height: 8),
            Text(
              'You are eligible for placements.',
              style: TextStyle(fontSize: 16, color: thirdColor),
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
