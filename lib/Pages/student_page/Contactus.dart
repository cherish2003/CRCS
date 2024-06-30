import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:crcs/api/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact us'),
        backgroundColor: mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CardView(
              title: 'Corporate Relations & Career Services',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email: crcs.helpdesk@srmap.edu.in',
                    style: TextStyle(fontSize: 18, color: thirdColor),
                  ),
                  SizedBox(height: 8),
                ],
              ),
              color: secondaryColor,
            ),
            const SizedBox(height: 25),
            FutureBuilder<MentorDetails>(
              future: fetchMentorDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return Center(child: Text('No data available'));
                }

                final mentor = snapshot.data!;
                return CardView(
                  title: 'Mentor Details:',
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ${mentor.name}',
                        style: TextStyle(
                          fontSize: 18,
                          color: thirdColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Email: ${mentor.email}',
                        style: TextStyle(
                          fontSize: 18,
                          color: thirdColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Cabin: ${mentor.cabin}',
                        style: TextStyle(
                          fontSize: 18,
                          color: thirdColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Phone number: ${mentor.phoneNumber}',
                        style: TextStyle(
                          fontSize: 18,
                          color: thirdColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  color: secondaryColor,
                );
              },
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

Future<MentorDetails> fetchMentorDetails() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("Token");
  print(token);

  if (token == null) {
    throw Exception("Token not found");
  }

  final url = Uri.parse(getStudMentor);

  try {
    final res = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print(res.statusCode);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      print("data ::: $data");

      final mentorData = data['data']['men'];
      if (mentorData == null) {
        return MentorDetails.empty();
      }

      return MentorDetails.fromJson(mentorData);
    } else {
      throw Exception("Failed to load mentor details");
    }
  } catch (e) {
    print(e);
    throw Exception("Error: $e");
  }
}

class MentorDetails {
  final String name;
  final String email;
  final String cabin;
  final String phoneNumber;

  MentorDetails({
    required this.name,
    required this.email,
    required this.cabin,
    required this.phoneNumber,
  });

  factory MentorDetails.fromJson(Map<String, dynamic> json) {
    return MentorDetails(
      name: json['name'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
      cabin: json['cabin'].toString(),
      phoneNumber: json['phoneno'].toString(),
    );
  }

  factory MentorDetails.empty() {
    return MentorDetails(
      name: 'N/A',
      email: 'N/A',
      cabin: 'N/A',
      phoneNumber: 'N/A',
    );
  }
}
