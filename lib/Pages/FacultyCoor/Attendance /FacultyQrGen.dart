import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crcs/config.dart';

class FacultyQrgen extends StatefulWidget {
  final String eventId;

  const FacultyQrgen({Key? key, required this.eventId}) : super(key: key);

  @override
  State<FacultyQrgen> createState() => _FacultyQrgenState();
}
class _FacultyQrgenState extends State<FacultyQrgen> {
  List<String>? tokens;
  int currentIndex = 0;
  Timer? fetchTimer; 
  Timer? tokenTimer;
  bool isSessionStarted = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    fetchTimer?.cancel();
    tokenTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchTokens() async {
    print(widget.eventId);
    setState(() {
      currentIndex = 0;
      isLoading = true; // Set loading to true when fetching starts
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("Token");

    if (token == null) {
      setState(() {
        isLoading = false; // Set loading to false if token is null
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$getQrtokens'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'sessionId': widget.eventId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        setState(() {
          tokens = List<String>.from(responseBody['data']['tokens']);
          print(tokens);
          currentIndex = 0; // Reset currentIndex
          isLoading = false; // Set loading to false when tokens are received
        });
        startTokenTimer();
      } else {
        print(response.statusCode);
        setState(() {
          isLoading = false; // Set loading to false on error
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false; // Set loading to false on error
      });
    }
  }

  void startTokenTimer() {
    if (tokens != null && tokens!.isNotEmpty) {
      // Cancel the existing timer if any
      tokenTimer?.cancel();
      // Show each token once per session
      currentIndex = 0; // Start from the first token
      tokenTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
        setState(() {
          if (currentIndex < tokens!.length - 1) {
            currentIndex++;
          } else {
            // Reached the end of tokens for this session
            timer.cancel(); // Stop the timer
          }
        });
      });
    }
  }

  void startSession() {
    setState(() {
      isSessionStarted = true;
    });

    // Start fetching immediately
    fetchTokens();

    // Fetch tokens every 60 seconds until the session is stopped
    fetchTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      if (isSessionStarted) {
        fetchTokens();
      } else {
        timer.cancel();
      }
    });
  }

  void stopSession() {
    setState(() {
      isSessionStarted = false;
      tokens = null; 
      fetchTimer?.cancel(); 
      tokenTimer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR generator"),
        backgroundColor: mainColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CardView(
            title: 'QR Code',
            content: Column(
              children: [
                if (isLoading) // Show loading indicator if isLoading is true
                  const Center(
                    child: CircularProgressIndicator(
                      color: mainColor,
                    ),
                  ),
                if (isSessionStarted && !isLoading && tokens == null)
                  const Text(
                    'No tokens available',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (tokens != null &&
                    tokens!.isNotEmpty &&
                    isSessionStarted &&
                    !isLoading)
                  QrImageView(
                    data: tokens![currentIndex],
                    version: QrVersions.auto,
                    size: 350.0,
                  ),
                const SizedBox(height: 16.0),
                Text(
                  tokens != null
                      ? 'Token ${currentIndex + 1} of ${tokens!.length}'
                      : 'Session not started',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: isSessionStarted ? null : startSession,
                      icon: Icon(
                        Icons.start_outlined,
                        color: Colors.green,
                      ),
                      label: Text(
                        "Start session",
                        style: TextStyle(fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(20, 60),
                        backgroundColor: thirdColor,
                        foregroundColor: secondaryColor,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: isSessionStarted ? stopSession : null,
                      icon: Icon(
                        Icons.stop,
                        color: Colors.red,
                      ),
                      label: Text(
                        "Stop session",
                        style: TextStyle(fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(20, 60),
                        backgroundColor: thirdColor,
                        foregroundColor: secondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CardView extends StatelessWidget {
  final String title;
  final Widget content;

  const CardView({Key? key, required this.title, required this.content})
      : super(key: key);

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
