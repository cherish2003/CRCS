import 'package:flutter/material.dart';

const Color mainColor = Color(0xff6a6446);
const Color secondaryColor = Color(0xfff2f0e4);
const Color thirdColor = Color(0xff403a1f);
const Color fourthColor = Color(0xffbf7d2c);

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List<Event> events = [
    Event(
      name: "Flutter Workshop",
      date: DateTime(2024, 5, 10),
      duration: Duration(hours: 2),
    ),
    Event(
      name: "Dart Conference",
      date: DateTime(2024, 5, 15),
      duration: Duration(hours: 3),
    ),
    // Add more events here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upcoming Events'),
        backgroundColor: mainColor,
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4.0,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            color: secondaryColor,
            child: ListTile(
              title: Text(
                events[index].name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: fourthColor,
                ),
              ),
              subtitle: Text(
                'Starts: ${events[index].date.toString()}\nDuration: ${events[index].duration.inHours} hours',
                style: TextStyle(color: thirdColor),
              ),
              onTap: () {
                // Define what happens when an event is tapped
              },
            ),
          );
        },
      ),
    );
  }
}

class Event {
  String name;
  DateTime date;
  Duration duration;

  Event({required this.name, required this.date, required this.duration});
}

void main() => runApp(MaterialApp(
      home: EventPage(),
      theme: ThemeData(
        primaryColor: mainColor,
      ),
    ));
