import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

const Color mainColor = Color(0xff6a6446);
const Color secondaryColor = Color(0xfff2f0e4);
const Color thirdColor = Color(0xff403a1f);
const Color fourthColor = Color(0xffbf7d2c);

class Announcements extends StatefulWidget {
  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  List<Event> events = [
    // Event(
    //   name: "Flutter Workshop",
    //   date: DateTime(2024, 5, 10),
    //   duration: Duration(hours: 2),
    // ),

    // Add more events here
  ];

  @override
  void initState() {
    OneSignal.Debug.setLogLevel(OSLogLevel.debug);
    OneSignal.initialize("a6e44ad7-41e9-4eac-96bb-2470d434f211");
    OneSignal.Notifications.requestPermission(true).then((value) {
      print("signal value ${value}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcements'),
        backgroundColor: mainColor,
      ),
      body: ListView.builder(
        itemCount: events.length + 1, // +1 for the info card
        itemBuilder: (context, index) {
          if (index == 0) {
            return CardView(
              title: 'Upcoming Announcements Information',
              content: Text(
                'This page contains all the announcements  about upcoming meetings, alumni meetings, and other events.',
                style: TextStyle(color: thirdColor),
              ),
              color: secondaryColor,
            );
          } else {
            final event = events[index - 1]; // Adjust index for the event list
            return Card(
              elevation: 4.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              color: secondaryColor,
              child: ListTile(
                title: Text(
                  event.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: fourthColor,
                  ),
                ),
                subtitle: Text(
                  'Starts: ${event.date.toString()}\nDuration: ${event.duration.inHours} hours',
                  style: TextStyle(color: thirdColor),
                ),
                onTap: () {
                  // Define what happens when an event is tapped
                },
              ),
            );
          }
        },
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
      margin: EdgeInsets.all(16.0),
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

class Event {
  String name;
  DateTime date;
  Duration duration;

  Event({required this.name, required this.date, required this.duration});
}

void main() => runApp(MaterialApp(
      home: Announcements(),
      theme: ThemeData(
        primaryColor: mainColor,
      ),
    ));
