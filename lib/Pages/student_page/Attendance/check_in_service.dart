import 'package:crcs/Pages/student_page/Attendance/Student_attendance.dart';
import 'package:crcs/components/checkmark.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class CheckInWidget extends StatefulWidget {
  @override
  _CheckInWidgetState createState() => _CheckInWidgetState();
}

class _CheckInWidgetState extends State<CheckInWidget> {
  int flag = 0;
  bool capture = true;
  void _checkIn() async {
    String message;
    setState(() {
      flag = 2;
    });
    try {
      Position position = await _determinePosition();
      print("Current position: ${position.latitude}, ${position.longitude}");

      final double destinationLatitude = 16.463638;
      final double destinationLongitude = 80.507547;
      // 16.463638, 80.507547
      double dist = await Geolocator.distanceBetween(position.latitude,
          position.longitude, destinationLatitude, destinationLongitude);
      print(dist);

      if (dist <= 45) {
        // await _sendCheckInData(position);
        message = 'Check-in successful!';
      } else {
        message = 'You are not within the auditorium area.';
      }
    } catch (e) {
      message = 'Error: ${e.toString()}';
    }
    _showMessage(message);
  }

  Future<void> _sendCheckInData(Position position) async {
    final response = await http.post(
      Uri.parse('https://yourserver.com/checkin'),
      body: {
        'latitude': position.latitude.toString(),
        'longitude': position.longitude.toString(),
        'timestamp': position.timestamp?.toIso8601String() ??
            DateTime.now().toIso8601String(),
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to check in on server.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Attendance : Location",
              style: TextStyle(color: Colors.white)),
          backgroundColor: mainColor),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (flag == 0)
              Column(
                children: [
                  const SizedBox(height: 10),
                  const Text("Mark attendance ",
                      style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: capture
                        ? () {
                            _checkIn();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: mainColor,
                      minimumSize: const Size(100, 60),
                      maximumSize: const Size(150, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Capture", style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(
                        16.0), // or EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0) for specific margins
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        const Text(
                          "Note: \n\n1. This attendance option is only valid for auditorium students\n\n2. Location services should be given permission or else your attendance will not captured\n\n3. Capture button will be enabled as soon as mentor starts the attendance session and expires within time period set by mentor or until mentor stops the session ",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            else if (flag == 1)
              Center(
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("You are not within the auditorium area.!! \n Try again !!",
                            style: TextStyle(fontSize: 16,color: Colors.red)),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            flag = 0;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              mainColor,
                          minimumSize: const Size(100, 60),
                          maximumSize: const Size(150, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        child: const Row(
                          children: [
                            SizedBox(width: 8),
                            Icon(Icons.logout, size: 26, color: Colors.white),
                            SizedBox(width: 10),
                            Text("Back", style: TextStyle(fontSize: 18)),
                          ],
                        )),
                  ],
                ),
              )
            else if(flag == 2)
            Center(
                child: Column(
                  children: [
                    const CheckMarkPage(),
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Attendance recorded!",
                            style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                        onPressed: () {
                        setState(() {
                            flag = 0;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              mainColor,
                          minimumSize: const Size(100, 60),
                          maximumSize: const Size(150, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        child: const Row(
                          children: [
                            SizedBox(width: 8),
                            Icon(Icons.logout, size: 26, color: Colors.white),
                            SizedBox(width: 10),
                            Text("Back", style: TextStyle(fontSize: 18)),
                          ],
                        )),
                  ],
                ),
              )

          ],
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    } else if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
  }
}

const Color mainColor = Color(0xff6a6446);
const Color secondaryColor = Color(0xfff2f0e4);
const Color thirdColor = Color(0xff403a1f);
const Color fourthColor = Color(0xffbf7d2c);
