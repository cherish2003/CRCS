import 'dart:convert';
import 'package:crcs/config.dart';
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
    print(_token);
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
        // Process the response data here
        print(_jsonData['appliedCompany'][_rollno].length);
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
    _counts['appliedCompany'] = _jsonData['appliedCompany'][_rollno].length;
    _counts['eligibleCompany'] = _jsonData['eligibleCompany'][_rollno].length;
    _counts['placed'] = _jsonData['placed'][_rollno].length;
    _counts['shortlistedCompany'] =
        _jsonData['shortlistedCompany'][_rollno].length;
    _counts['placed'] = _jsonData['placed'][_rollno].length;
    _counts['gd'] = _jsonData['stages'][_rollno]['gd'].length;
    _counts['hr'] = _jsonData['stages'][_rollno]['hr'].length;
    _counts['inter'] = _jsonData['stages'][_rollno]['inter'].length;
    _counts['ot'] = _jsonData['stages'][_rollno]['ot'].length;
    _counts['other'] = _jsonData['stages'][_rollno]['other'].length;
    setState(() {});
  }

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
