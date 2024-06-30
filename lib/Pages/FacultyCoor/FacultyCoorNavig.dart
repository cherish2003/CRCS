import 'package:crcs/Pages/FacultyCoor/FacultyCoorSessions.dart';
import 'package:crcs/Pages/student_page/Attendance/Attendance.dart';
import 'package:crcs/Pages/student_page/CompanyFeedback.dart';
import 'package:crcs/Pages/student_page/Contactus.dart';
import 'package:crcs/Pages/student_page/Announcements.dart';
import 'package:crcs/Pages/student_page/PlacementPolicy.dart';
import 'package:crcs/Pages/student_page/StudentFeedback.dart';
import 'package:crcs/Pages/student_page/Studentinfo.dart';
import 'package:crcs/Pages/student_page/mypratice.dart';
import 'package:flutter/material.dart';

class FacultyCoorNavig extends StatefulWidget {
  const FacultyCoorNavig({Key? key}) : super(key: key);

  @override
  _FacultyCoorNavigState createState() => _FacultyCoorNavigState();
}

class _FacultyCoorNavigState extends State<FacultyCoorNavig> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Faculty home page'),
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
          )),
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
                      builder: (context) => const FacultyCoorNavig()),
                );
              },
              hoverColor: thirdColor.withOpacity(0.5),
            ),
            ListTile(
              title: const Text('Sessions'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FacultyCoorSessions()),
                );
              },
              hoverColor: thirdColor.withOpacity(0.5),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          CardView(
            title: 'Information',
            content:
                'Faculty coordinators are responsible for taking the attedance of students  \n\n1. Ensure the students take attendance before session stops \n\n2. For students within auditorium before the attendance session is started ensure inform them to give permissions to their location once they click on the (capture button) or else attendance cannot be captured \n\n3. Once all students have recorded their attendance you can stop the session and submit the attendance for that session',
            color: secondaryColor,
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}

class CompanyTile extends StatelessWidget {
  final String companyName;
  final count;

  const CompanyTile({required this.companyName, required this.count});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        '$companyName : $count',
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w700, color: thirdColor),
      ),
      // subtitle: Text('Type: $type\nExpected Date: $expectedDate2'),
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
