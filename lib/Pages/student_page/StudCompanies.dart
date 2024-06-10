import 'dart:convert';
import 'package:crcs/Pages/FacultyCoor/EventDetails.dart';
import 'package:crcs/Pages/student_page/StudCompanyDetails.dart';
import 'package:crcs/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
// import 'CompanyDetails.dart'; // Import the new screen

class Studcompanies extends StatefulWidget {
  const Studcompanies({super.key});

  @override
  State<Studcompanies> createState() => _StudcompaniesState();
}

class _StudcompaniesState extends State<Studcompanies> {
  List<Event> events = [];
  List<Event> filteredEvents = [];
  bool isLoading = true;
  String filterTime = 'All';
  String rollNumber = '0';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("Token");
    final String? batch = prefs.getString("Batch");
    rollNumber = prefs.getString("Rollno") ?? '0';

    if (token == null || batch == null) {
      print("Token or batch is null");
      return;
    }

    final url = Uri.parse("$getStuComp/$batch");
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final parsedJson = jsonDecode(response.body);
        List<dynamic>? data = parsedJson['data']['comp'];
        print(data);
        if (data != null) {
          setState(() {
            events = data.map((json) => Event.fromJson(json)).toList();
            filteredEvents = events;
            isLoading = false;
          });
          // Print the list of events for debugging
          print("Events :$events");
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterEvents(String category) {
    setState(() {
      filterTime = category;
      if (category == 'All') {
        filteredEvents = events;
      } else if (category == 'Expected') {
        filteredEvents = events.where((event) {
          final eventDate = DateTime.parse(event.dateOfVisit).toLocal();
          final currentDate = DateTime.now();
          return eventDate.isAfter(currentDate);
        }).toList();
      } else if (category == 'Placed') {
        filteredEvents = events.where((event) {
          return event.placedStudents.contains(rollNumber);
        }).toList();
      } else if (category == 'Shortlisted') {
        filteredEvents = events.where((event) {
          return event.shortlistedStudents.contains(rollNumber);
        }).toList();
      } else if (category == 'Applied') {
        filteredEvents = events.where((event) {
          return event.appliedStudents.contains(rollNumber);
        }).toList();
      } else if (category == 'Eligible') {
        filteredEvents = events.where((event) {
          return event.eligibleStudents.contains(rollNumber);
        }).toList();
      }
      // Debugging: Print filtered results
      print("Filtered Events for $category: $filteredEvents $rollNumber");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Companies'),
        backgroundColor: mainColor,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 35),
                ElevatedButton(
                  onPressed: () => filterEvents('All'),
                  child: Text('All'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        filterTime == 'All' ? Colors.white : mainColor,
                    backgroundColor:
                        filterTime == 'All' ? mainColor : secondaryColor,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => filterEvents('Expected'),
                  child: Text('Expected'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        filterTime == 'Expected' ? Colors.white : mainColor,
                    backgroundColor:
                        filterTime == 'Expected' ? mainColor : secondaryColor,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => filterEvents('Placed'),
                  child: Text('Placed'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        filterTime == 'Placed' ? Colors.white : mainColor,
                    backgroundColor:
                        filterTime == 'Placed' ? mainColor : secondaryColor,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => filterEvents('Shortlisted'),
                  child: Text('Shortlisted'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        filterTime == 'Shortlisted' ? Colors.white : mainColor,
                    backgroundColor: filterTime == 'Shortlisted'
                        ? mainColor
                        : secondaryColor,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => filterEvents('Applied'),
                  child: Text('Applied'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        filterTime == 'Applied' ? Colors.white : mainColor,
                    backgroundColor:
                        filterTime == 'Applied' ? mainColor : secondaryColor,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => filterEvents('Eligible'),
                  child: Text('Eligible'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        filterTime == 'Eligible' ? Colors.white : mainColor,
                    backgroundColor:
                        filterTime == 'Eligible' ? mainColor : secondaryColor,
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                  color: mainColor,
                ))
              : Expanded(
                  child: ListView.builder(
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      bool isShortlisted = filteredEvents[index]
                          .shortlistedStudents
                          .contains(rollNumber);
                      bool isPlaced = filteredEvents[index]
                          .placedStudents
                          .contains(rollNumber);
                      bool isApplied = filteredEvents[index]
                          .appliedStudents
                          .contains(rollNumber);
                      bool isEligible = filteredEvents[index]
                          .eligibleStudents
                          .contains(rollNumber);

                      return Card(
                        child: ListTile(
                          title: Text(filteredEvents[index].name),
                          subtitle: Text(
                              'CTC: ${filteredEvents[index].CTC}\nJob Role: ${filteredEvents[index].jobRole}\nJob Location: ${filteredEvents[index].jobLoc}'),
                          tileColor: secondaryColor,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Studcompanydetails(
                                  event: filteredEvents[index],
                                  isShortlisted: isShortlisted,
                                  isPlaced: isPlaced,
                                  isApplied: isApplied,
                                  isEligible: isEligible,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

class Event {
  final String name;
  final String CTC;
  final String jobRole;
  final String jobLoc;
  final String dateOfVisit;
  final String driveStatus;
  final List<String> placedStudents;
  final List<String> shortlistedStudents;
  final List<String> appliedStudents;
  final List<String> eligibleStudents;
  final List<String> branches;

  Event({
    required this.name,
    required this.CTC,
    required this.jobRole,
    required this.jobLoc,
    required this.dateOfVisit,
    required this.driveStatus,
    required this.placedStudents,
    required this.shortlistedStudents,
    required this.appliedStudents,
    required this.eligibleStudents,
    required this.branches,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      name: json['name'] ?? '',
      CTC: json['CTC'] ?? '',
      jobRole: json['jobRole'] ?? '',
      jobLoc: json['jobLoc'] ?? '',
      dateOfVisit: json['dateOfVisit'] ?? '',
      driveStatus: json['driveStatus'] ?? '',
      placedStudents: List<String>.from(json['placedStudents'] ?? []),
      shortlistedStudents: List<String>.from(json['shortlistedStudents'] ?? []),
      appliedStudents: List<String>.from(json['appliedStudents'] ?? []),
      eligibleStudents: List<String>.from(json['eligibleStudents'] ?? []),
      branches: List<String>.from(json['branches'] ?? []),
      // stages: List<String>.from(json['stages'] ?? []),
    );
  }

  @override
  String toString() {
    return 'Event{name: $name, CTC: $CTC, jobRole: $jobRole, jobLoc: $jobLoc, dateOfVisit: $dateOfVisit, placedStudents: $placedStudents, shortlistedStudents: $shortlistedStudents, appliedStudents: $appliedStudents, eligibleStudents: $eligibleStudents}';
  }
}

const Color mainColor = Color(0xff6a6446);
const Color secondaryColor = Color(0xfff2f0e4);
const Color thirdColor = Color(0xff403a1f);
const Color fourthColor = Color(0xffbf7d2c);
