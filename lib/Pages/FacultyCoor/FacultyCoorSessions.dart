import 'dart:convert';
import 'package:crcs/Pages/FacultyCoor/EventDetails.dart';
import 'package:crcs/api/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FacultyCoorSessions extends StatefulWidget {
  const FacultyCoorSessions({super.key});

  @override
  State<FacultyCoorSessions> createState() => _FacultyCoorSessionsState();
}

class _FacultyCoorSessionsState extends State<FacultyCoorSessions> {
  List<Event> events = [];
  List<Event> filteredEvents = [];
  bool isLoading = true;
  String filterTime = 'All';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("Token");
    if (token == null) {
      print("Token is null");
      return;
    }

    final url = Uri.parse(getEvents);
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
        List<dynamic> data = parsedJson['data'];
        print(data);
        setState(() {
          events = data.map((json) => Event.fromJson(json)).toList();
          filteredEvents = events;
          isLoading = false;
        });
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

  void filterEvents(String time) {
    setState(() {
      filterTime = time;
      if (time == 'All') {
        filteredEvents = events;
      } else if (time == 'Morning') {
        filteredEvents = events.where((event) {
          final startTime = DateTime.parse(event.startTime).toLocal();
          return startTime.hour >= 9 && startTime.hour < 12;
        }).toList();
      } else if (time == 'Afternoon') {
        filteredEvents = events.where((event) {
          final startTime = DateTime.parse(event.startTime).toLocal();
          return startTime.hour >= 13 && startTime.hour < 17;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upcoming Sessions'),
        backgroundColor: mainColor,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 20),
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
                  onPressed: () => filterEvents('Morning'),
                  child: Text('9:30 AM - 12:30 PM'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        filterTime == 'Morning' ? Colors.white : mainColor,
                    backgroundColor:
                        filterTime == 'Morning' ? mainColor : secondaryColor,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => filterEvents('Afternoon'),
                  child: Text('1:30 PM - 5:30 PM'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        filterTime == 'Afternoon' ? Colors.white : mainColor,
                    backgroundColor:
                        filterTime == 'Afternoon' ? mainColor : secondaryColor,
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
                      return Card(
                        elevation: 4.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        color: secondaryColor,
                        child: ExpansionTile(
                          title: Text(
                            filteredEvents[index].name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: fourthColor,
                            ),
                          ),
                          subtitle: Text(
                            'Starts: ${filteredEvents[index].date}\nDuration: ${filteredEvents[index].duration.inHours} hours',
                            style: TextStyle(color: thirdColor),
                          ),
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20.0, 3.0, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${filteredEvents[index].description}\n",
                                      style: TextStyle(color: thirdColor),
                                      overflow: TextOverflow.ellipsis),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Text(
                                          "Start-Time: ${DateTime.parse(filteredEvents[index].startTime).toLocal().toString().split(' ')[1].substring(0, 5)}\n",
                                          style: TextStyle(color: thirdColor),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "End-Time: ${DateTime.parse(filteredEvents[index].endTime).toLocal().toString().split(' ')[1].substring(0, 5)}\n",
                                          style: TextStyle(color: thirdColor),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ButtonBar(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EventDetails(
                                            event: filteredEvents[index]),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: mainColor,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text('Join Event'),
                                ),
                              ],
                            ),
                          ],
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
  String id;
  String name;
  DateTime date;
  Duration duration;
  String description;
  String startTime;
  String endTime;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.duration,
    required this.description,
    required this.startTime,
    required this.endTime,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'],
      name: json['name'],
      date: DateTime.parse(json['startTime']),
      duration: DateTime.parse(json['endTime'])
          .difference(DateTime.parse(json['startTime'])),
      description: json['des'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }
}

const Color mainColor = Color(0xff6a6446);
const Color secondaryColor = Color(0xfff2f0e4);
const Color thirdColor = Color(0xff403a1f);
const Color fourthColor = Color(0xffbf7d2c);
