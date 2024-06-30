import 'dart:convert';
import 'package:crcs/Pages/student_page/Attendance/Attendance.dart';
import 'package:crcs/Pages/student_page/CompanyFeedback.dart';
import 'package:crcs/Pages/student_page/Contactus.dart';
import 'package:crcs/Pages/student_page/Announcements.dart';
import 'package:crcs/Pages/student_page/PlacementPolicy.dart';
import 'package:crcs/Pages/student_page/StudCompanies.dart';
import 'package:crcs/Pages/student_page/StudentFeedback.dart';
import 'package:crcs/Pages/student_page/Studentinfo.dart';
import 'package:crcs/Pages/student_page/mypratice.dart';
import 'package:crcs/api/config.dart';
import 'package:crcs/utils/TokenManger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StudentHomepage extends StatefulWidget {
  const StudentHomepage({Key? key}) : super(key: key);

  @override
  _StudentHomepageState createState() => _StudentHomepageState();
}

class _StudentHomepageState extends State<StudentHomepage> {
  late SharedPreferences _prefs;
  late String _token;
  late String _rollno;
  late String _batch;
  late Map<String, dynamic> _jsonData;

  late Map<String, int> _counts = {};

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    _prefs = await SharedPreferences.getInstance();
    _token = _prefs.getString("Token") ?? "";
    _rollno = _prefs.getString("Rollno") ?? "";
    _batch = _prefs.getString("Batch") ?? "";

    await fetchPlacementProgress();

    if (_jsonData.isNotEmpty) {
      // Check if data is not empty
      _calculateCounts();
      print(_counts);
    }
  }

  Future<void> fetchPlacementProgress() async {
    try {
      final response = await http.post(
        Uri.parse('$getStudProgress/$_batch'),
        headers: {
          "Authorization": "Bearer $_token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "rollno": [_rollno]
        }),
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);

        _jsonData = res['data'];
        print(_jsonData);
        print(_jsonData['appliedCompany'][_rollno].length);
        // Process the response data here
      } else {
        // Handle error response
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors
      print('Error: $e');
    }
  }

  void _calculateCounts() {
    // Initialize counts with default values
    _counts = {
      'appliedCompany': 0,
      'eligibleCompany': 0,
      'placed': 0,
      'shortlistedCompany': 0,
      'gd': 0,
      'hr': 0,
      'ot': 0,
      'other': 0,
      'inter': 0,
    };

    if (_jsonData != null) {
      if (_jsonData.containsKey('eligibleCompany') &&
          _jsonData['eligibleCompany'].containsKey(_rollno)) {
        _counts['eligibleCompany'] =
            _jsonData['eligibleCompany'][_rollno]?.length ?? 0;
      }

      if (_jsonData.containsKey('appliedCompany') &&
          _jsonData['appliedCompany'].containsKey(_rollno)) {
        _counts['appliedCompany'] =
            _jsonData['appliedCompany'][_rollno]?.length ?? 0;
      }

      if (_jsonData.containsKey('placed') &&
          _jsonData['placed'].containsKey(_rollno)) {
        _counts['placed'] = _jsonData['placed'][_rollno]?.length ?? 0;
      }

      if (_jsonData.containsKey('shortlistedCompany') &&
          _jsonData['shortlistedCompany'].containsKey(_rollno)) {
        _counts['shortlistedCompany'] =
            _jsonData['shortlistedCompany'][_rollno]?.length ?? 0;
      }

      if (_jsonData.containsKey('stages') &&
          _jsonData['stages'].containsKey(_rollno)) {
        final stages = _jsonData['stages'][_rollno];

        _counts['gd'] = stages['gd']?.length ?? 0;
        _counts['hr'] = stages['hr']?.length ?? 0;
        _counts['ot'] = stages['ot']?.length ?? 0;
        _counts['other'] = stages['other']?.length ?? 0;

        _counts['inter'] = (stages['inter1']?.length ?? 0) +
            (stages['inter2']?.length ?? 0) +
            (stages['inter3']?.length ?? 0);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Home Page'),
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
                      builder: (context) => const StudentHomepage()),
                );
              },
              hoverColor: thirdColor.withOpacity(0.5),
            ),
            ListTile(
              title: const Text('Info'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CardExample()),
                );
              },
              hoverColor: thirdColor.withOpacity(0.5),
            ),
            ListTile(
              title: const Text('Announcements'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Announcements()),
                );
              },
              hoverColor: thirdColor.withOpacity(0.5),
            ),
            ListTile(
              title: const Text('Attendance'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Attendance()),
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
              title: const Text('Companies'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Studcompanies()),
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
              title: const Text('Mentor Feedback'),
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
              title: const Text('Contact us'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactUs()),
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
                    'Your placement info',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: fourthColor,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  CompanyTile(
                    companyName: 'Eligible Companies',
                    count: _counts['eligibleCompany'],
                  ),
                  Divider(), // Line break
                  CompanyTile(
                    companyName: 'Applied Companies',
                    count: _counts['appliedCompany'],
                  ),
                  Divider(), // Line break
                  CompanyTile(
                    companyName: 'Shortlisted Companies',
                    count: _counts['shortlistedCompany'],
                  ),
                  Divider(), // Line break
                  CompanyTile(
                    companyName: 'Placed Companies',
                    count: _counts['placed'],
                  ),
                  Divider(), // Line break
                  CompanyTile(
                    companyName: 'Eligible Companies',
                    count: _counts['eligibleCompany'],
                  ),
                  Divider(),
                  CompanyTile(
                    companyName: 'Online test',
                    count: _counts['ot'],
                  ),
                  Divider(),
                  Text(
                    'In progress stages',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: fourthColor,
                    ),
                  ),

                  CompanyTile(
                    companyName: 'GD',
                    count: _counts['gd'],
                  ),
                  CompanyTile(
                    companyName: 'Interview',
                    count: _counts['inter'],
                  ),
                  CompanyTile(
                    companyName: 'HR',
                    count: _counts['hr'],
                  ),
                  CompanyTile(
                    companyName: 'GD',
                    count: _counts['gd'],
                  ),

                  CompanyTile(
                    companyName: 'other',
                    count: _counts['other'],
                  ),
                  // Line break
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
