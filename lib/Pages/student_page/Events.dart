import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart'; // Add this import

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
              onTap: () async {
                bool permissionGranted = await _checkCameraPermission();
                if (permissionGranted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QRScanPage(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Camera permission denied.'),
                  ));
                }
              },
            ),
          );
        },
      ),
    );
  }

  Future<bool> _checkCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }
}

class Event {
  String name;
  DateTime date;
  Duration duration;

  Event({required this.name, required this.date, required this.duration});
}

class QRScanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
        backgroundColor: mainColor,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // hi sanju here write logic after scanning
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
