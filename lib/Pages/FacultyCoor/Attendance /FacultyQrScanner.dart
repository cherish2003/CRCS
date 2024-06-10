import 'dart:io';
import 'package:crcs/Pages/FacultyCoor/FacultyCoorSessions.dart';
import 'package:crcs/Pages/student_page/StudentHomepage.dart';
import 'package:crcs/components/checkmark.dart';
import 'package:crcs/config.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Facultyqrscanner extends StatefulWidget {
  final String eventId;

  const Facultyqrscanner({required this.eventId, super.key});

  @override
  _FacultyqrscannerState createState() => _FacultyqrscannerState();
}

class _FacultyqrscannerState extends State<Facultyqrscanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  int flag = 0;
  bool isLoading = false;
  List<String> scannedRollNumbers = [];
  Set<String> newlyAddedRollNumbers = {};

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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (flag == 0)
              Container(
                height: 400, // Set an appropriate height for the QR scanner
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: Colors.red,
                    borderRadius: 3,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: 300,
                  ),
                ),
              ),
            if (flag == 0)
              Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Total Students Scanned: ${scannedRollNumbers.length}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 300, // Set an appropriate height for the DataTable
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text(
                              'Roll numbers',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              '',
                            ),
                          ),
                        ],
                        rows: scannedRollNumbers.map((rollNumber) {
                          return DataRow(
                            cells: <DataCell>[
                              DataCell(Text(rollNumber)),
                              DataCell(
                                newlyAddedRollNumbers.contains(rollNumber)
                                    ? Icon(Icons.check, color: Colors.green)
                                    : Container(),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  if (scannedRollNumbers.isNotEmpty)
                    ElevatedButton(
                      onPressed: _submitAllDataToServer,
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
                          Icon(Icons.done, size: 18, color: Colors.white),
                          SizedBox(
                            width: 8,
                          ),
                          Text("Submit", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                ],
              ),
          ],
        ),
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
      });

      if (scanData.code != null) {
        if (scannedRollNumbers.contains(scanData.code!)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Duplicate QR scanned !!!!',
                  style: TextStyle(color: Colors.red)),
              duration: Duration(seconds: 1),
            ),
          );
          controller.resumeCamera();
        } else {
          setState(() {
            scannedRollNumbers.add(scanData.code!);
            newlyAddedRollNumbers.add(scanData.code!);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                  'QR code added',
                  style: TextStyle(color: Colors.green),
                ),
                duration: Duration(seconds: 1)),
          );
          controller.resumeCamera();

          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              newlyAddedRollNumbers.remove(scanData.code!);
            });
          });
        }
      }
    });
  }

  Future<void> _submitAllDataToServer() async {
    setState(() {
      isLoading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("Token");
    final url = Uri.parse(submitStdAtt);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(
          {
            'roll_numbers': scannedRollNumbers,
            'sessionid': widget.eventId,
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        print('Data sent successfully');
        setState(() {
          isLoading = false;
          flag = 2;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FacultyCoorSessions()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            'Attendance submitted successfully!',
            style: TextStyle(color: Colors.green),
          )),
        );
      } else {
        setState(() {
          isLoading = false;
          flag = 1;
        });
        print('Failed to send data');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FacultyCoorSessions()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            'Failed to send data',
            style: TextStyle(color: Colors.red),
          )),
        );
      }
    } catch (e) {
      print('Error: $e');
      // setState({
      //   isLoading = false;
      //   flag = 1;
      // });
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
