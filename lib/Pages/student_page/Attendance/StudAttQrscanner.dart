import 'dart:io';
import 'package:crcs/Pages/student_page/StudentHomepage.dart';
import 'package:crcs/components/checkmark.dart';
import 'package:crcs/api/config.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  int flag = 0;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        backgroundColor: mainColor,
      ),
      body: Column(
        children: <Widget>[
          if (flag == 0)
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.red,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 300,
                ),
              ),
            ),
          if (flag == 1)
            Center(
              heightFactor: 3,
              child: Column(
                children: [
                  const Text(
                    "Qr expired\n Try again !!!",
                    style: TextStyle(
                        fontSize: 21,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
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
                      backgroundColor: mainColor,
                      minimumSize: const Size(100, 60),
                      maximumSize: const Size(150, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    child: Row(
                      children: const [
                        SizedBox(width: 8),
                        Icon(Icons.logout, size: 26, color: Colors.white),
                        SizedBox(width: 10),
                        Text("Back", style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (flag == 2)
            Center(
              heightFactor: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StudentHomepage()));
                      },
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
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        controller.stopCamera();
        print(scanData.code);
      });

      if (scanData.code != null) {
        _sendDataToServer(scanData.code!);
      }
    });
  }

  Future<void> _sendDataToServer(String data) async {
    setState(() {
      isLoading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("Token");
    final String? Rollno = prefs.getString("Rollno");
    final url = Uri.parse(markAtt); // Replace with your server endpoint
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, String?>{'qr_data': data, "rollno": Rollno}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        print('Data sent successfully');
        setState(() {
          isLoading = false;
          flag = 2;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Attendace captured successfully!')),
        );
      } else if (response.statusCode == 498) {
        setState(() {
          isLoading = false;
          flag = 1;
        });
        final res = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'])),
        );
      } else if (response.statusCode == 201) {
        final res = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            res['message'],
            style: TextStyle(
              color: Colors.red,
            ),
          )),
        );
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => StudentHomepage()));
      } else {
        setState(() {
          isLoading = false;
          flag = 1;
        });
        print('Failed to send data');
        // Handle error response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send data')),
        );
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
        flag = 1;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

const Color mainColor = Color(0xff6a6446);
const Color secondaryColor = Color(0xfff2f0e4);
const Color thirdColor = Color(0xff403a1f);
const Color fourthColor = Color(0xffbf7d2c);
