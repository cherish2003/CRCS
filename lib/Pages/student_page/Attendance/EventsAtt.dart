import 'dart:convert';
import 'package:crcs/api/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EventAtt extends StatefulWidget {
  const EventAtt({Key? key}) : super(key: key);

  @override
  State<EventAtt> createState() => _EventAttState();
}

class _EventAttState extends State<EventAtt> {
  List<Event> events = [];
  bool isLoading = false;
  late String _rollno;
  double _overAllATT = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("Token");
    final String? rollno = prefs.getString("Rollno");

    if (rollno != null) {
      _rollno = rollno;
    } else {
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (token == null) {
      print("Token is null");
      setState(() {
        isLoading = false;
      });
      return;
    }

    final url = Uri.parse('$getAttevts/$_rollno');

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
        List<dynamic> eventsData = parsedJson['data']['att'];
        print(eventsData);

        for (var eventData in eventsData) {
          events.add(Event.fromJson(eventData));
          print(eventData);
        }
        double overallPercentage =
            calculateOverallAttendancePercentage(events, _rollno);
        setState(() {
          _overAllATT = overallPercentage;
          isLoading = false;
        });

        print('Overall Percentage: ${overallPercentage.toStringAsFixed(2)}%');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Attendance'),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: mainColor,
                    ),
                  )
                : CardView(
                    title: 'Overall Attendance',
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${_overAllATT.toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _overAllATT >= 80
                                ? Colors.green
                                : Colors.red[800],
                          ),
                        ),
                        Text(
                          "Note : Maintain overall attendance of 80% to be eligible for placements ",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: events.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4.0,
                  margin: EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  color: secondaryColor,
                  child: ExpansionTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            events[index].name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: fourthColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 10), // Add some space between the texts
                        Text(
                          '${events[index].calculateAttendancePercentageForStudent(_rollno).toStringAsFixed(2) }%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: events[index]
                                        .calculateAttendancePercentageForStudent(
                                            _rollno ) <
                                    80
                                ? Colors.red
                                : Colors.green,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 3.0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Description: "),
                            Text(
                              events[index].description,
                              style: TextStyle(color: thirdColor),
                            ),
                            SizedBox(height: 8.0),
                            Text("Start time: "),
                            Text(
                              events[index].start_time.toString(),
                              style: TextStyle(color: thirdColor),
                            ),
                            SizedBox(height: 8.0),
                            Text("End time: "),
                            Text(
                              events[index].end_time.toString(),
                              style: TextStyle(color: thirdColor),
                            ),
                          ],
                        ),
                      ),
                      ButtonBar(
                        children: [
                          TextButton(
                            onPressed: () {
                              // Define what happens when an event is tapped
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventAttendanceDetails(
                                    event: events[index],
                                    rollNo: _rollno,
                                  ),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: mainColor,
                              foregroundColor: Colors.white,
                            ),
                            child: Text('View Details'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

double calculateOverallAttendancePercentage(
    List<Event> events, String rollNumber) {
  int totalDaysAttended = 0;
  int totalDays = 0;

  for (var event in events) {
    totalDays += event.attendanceData.length;

    totalDaysAttended += event.attendanceData.values
        .where((students) => students.contains(rollNumber))
        .length;
  }

  double overallPercentage = (totalDaysAttended / totalDays) * 100;
  return overallPercentage;
}

class Event {
  String id;
  String name;
  DateTime start_time;
  DateTime end_time;
  Duration duration;
  String description;
  Map<String, List<String>> attendanceData;

  Event({
    required this.id,
    required this.name,
    required this.start_time,
    required this.end_time,
    required this.duration,
    required this.description,
    required this.attendanceData,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'],
      name: json['name'],
      duration: DateTime.parse(json['endTime'])
          .difference(DateTime.parse(json['startTime'])),
      description: json['des'],
      start_time: DateTime.parse(json['startTime']),
      end_time: DateTime.parse(json['endTime']),
      attendanceData: (json['attendance'] as Map<String, dynamic>)
          .map<String, List<String>>(
        (key, value) => MapEntry<String, List<String>>(
          key,
          List<String>.from(value),
        ),
      ),
    );
  }

  double calculateAttendancePercentageForStudent(String rollNumber) {
    int totalDays = attendanceData.length;
    int daysPresent = 0;

    attendanceData.forEach((date, students) {
      if (students.contains(rollNumber)) {
        daysPresent++;
      }
    });

    double percentage = (daysPresent / totalDays) * 100;
    return percentage;
  }
}

class EventAttendanceDetails extends StatelessWidget {
  final Event event;
  final String rollNo;

  EventAttendanceDetails({required this.event, required this.rollNo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Details'),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            dataTextStyle: TextStyle(
                fontSize: 20, color: thirdColor, fontWeight: FontWeight.w600),
            columnSpacing: 80.0,
            columns: <DataColumn>[
              DataColumn(
                label: Text(
                  'Date',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: thirdColor),
                ),
              ),
              DataColumn(
                label: Text(
                  'Attendance',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: thirdColor),
                ),
              ),
            ],
            rows: event.attendanceData.entries.map((entry) {
              String date = entry.key;
              bool isPresent = entry.value.contains(rollNo);
              String attendanceStatus = isPresent ? 'Present' : 'Absent';

              return DataRow(
                color: MaterialStateColor.resolveWith(
                    (states) => Colors.transparent),
                cells: [
                  DataCell(
                    Text(
                      date,
                      style: TextStyle(color: thirdColor),
                    ),
                  ),
                  DataCell(
                    Text(
                      attendanceStatus,
                      style: TextStyle(
                        color: isPresent ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class CardView extends StatelessWidget {
  final String title;
  final Widget content;

  const CardView({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: secondaryColor,
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
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
