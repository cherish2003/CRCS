import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crcs/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CardExample extends StatefulWidget {
  const CardExample({Key? key}) : super(key: key);

  @override
  _CardExampleState createState() => _CardExampleState();
}

class _CardExampleState extends State<CardExample> {
  bool _isLoading = true; // Track loading state
  late Future<void> _dataFetchFuture; // Future for fetching data
  late Map<String, dynamic> _studentData; // Student data

  @override
  void initState() {
    super.initState();
    _dataFetchFuture = fetchData(); // Initialize future for data fetching
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("Token");

    if (token == null) {
      // Handle case where token is not found
      return;
    }

    final url = Uri.parse(getStudinfo);
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If the server returns a successful response, parse the JSON
      Map<String, dynamic> parsedJson = jsonDecode(response.body);
      print( parsedJson['data']['stu'][0]);
      setState(() {
        _isLoading = false;
        _studentData = parsedJson['data']['stu'][0];
      });
      print(_studentData);
      // prefs.setString("userData", parsedJson['data']['stu'][0]);
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Card Example'),
        backgroundColor: mainColor,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: mainColor,)) // Show loading indicator
          : FutureBuilder(
              future: _dataFetchFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child:
                          CircularProgressIndicator()); // Show loading indicator while fetching data
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text(
                          'Error: ${snapshot.error}')); // Show error if any
                } else {
                  return _buildCard(); // Show card with student details
                }
              },
            ),
    );
  }

  Widget _buildCard() {
    return Container(
      height: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Card(
              color: secondaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5, // Shadow elevation
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Student Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Text color
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: thirdColor),
                    _buildField('Student Name', _studentData['name'], context),
                    _buildField('Roll No', _studentData['rollno'], context),
                    _buildField('Phone', _studentData['phone'], context),
                    _buildField(
                        'Parent Phone', _studentData['parentphone'], context),
                    _buildField('Email', _studentData['email'], context),
                    _buildField('Mentor', _studentData['mentor'], context),
                    _buildField(
                        'Mentor Email', _studentData['mentoremail'], context),
                    _buildField('Branch', _studentData['branch'], context),
                    _buildField('Course', _studentData['course'], context),
                    _buildField('Batch', _studentData['batch'], context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String title, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title:',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: mainColor,
              // Text color
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Text color
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const Color mainColor = Color(0xff6a6446);
const Color secondaryColor = Color(0xfff2f0e4);
const Color thirdColor = Color(0xff403a1f);
const Color fourthColor = Color(0xffbf7d2c);
