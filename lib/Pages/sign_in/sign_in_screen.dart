import 'dart:convert';

import 'package:crcs/Pages/FacultyCoor/FacultyCoorNavig.dart';
import 'package:crcs/Pages/sign_in/components/Get_deviceinfo.dart';
import 'package:crcs/Pages/student_page/StudentHomepage.dart';
import 'package:crcs/api/config.dart';
import 'package:flutter/material.dart';
import 'package:crcs/Pages/sign_in/components/Register_user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isLoading = false;

  String? errorMessage;
  String? successMessage;

  Future<String> encryptDeviceInfo(String deviceInfo) async {
    final storage = const FlutterSecureStorage();
    final key = await storage.read(key: 'SRMAP_APP');
    final iv = await storage.read(key: 'iv');

    if (key == null || iv == null) {
      throw Exception('Key or IV not found');
    }

    final keyBytes = encrypt.Key.fromUtf8(key);
    final ivBytes = encrypt.IV.fromUtf8(iv);
    final encrypter =
        encrypt.Encrypter(encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc));

    final encrypted = encrypter.encrypt(deviceInfo, iv: ivBytes);
    return encrypted.base64;
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final info = await getDeviceInfo();
    final encryptedDeviceInfo = await encryptDeviceInfo(jsonEncode(info));

    var response = await http.post(
      Uri.parse(login),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'encryptedDeviceInfo': encryptedDeviceInfo}),
    );
    var responseData = jsonDecode(response.body);
    print(response);

    if (response.statusCode == 200) {
      if (responseData['role'] == "student") {
        var token = responseData['token'];
        var rollno = responseData['userData']['rollno'];
        var batch = responseData['userData']['yearofpassing'];
        print("Rollno: $rollno");
        print("Batch: $batch");
        if (token != null) {
          prefs.setString("Token", token);
        } else {
          print("Token is null");
        }
        if (rollno != null) {
          prefs.setString("Rollno", rollno);
        } else {
          print("Rollno is null");
        }
        if (batch != null) {
          prefs.setString("Batch", batch);
        } else {
          print("Batch is null");
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StudentHomepage()),
        );
      } else if (responseData['role'] == 'coor') {
        var token = responseData['token'];
        if (token != null) {
          prefs.setString("Token", token);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FacultyCoorNavig()),
          );
        } else {
          print("Token is null");
        }
      }
    } else if (response.statusCode == 404) {
      setState(() {
        errorMessage = responseData['error'];
      });
    } else {
      setState(() {
        errorMessage = "Login failed !!!";
      });
      print("Login failed");
    }
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await fetchData();
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: mainColor,
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome",
                  style: TextStyle(
                      color: thirdColor,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.5),
                ),
                const SizedBox(height: 13), // Space above the line
                const Divider(), // Horizontal line
                const SizedBox(height: 20), // Space below the line
                const Text("Login with registered device ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: thirdColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    )),
                const SizedBox(height: 16),
                const Text("if not registered kindly register with your device",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: thirdColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    )),
                const SizedBox(height: 20), // Space below the text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                            return const RegisterUser();
                          }),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(140, 60),
                        backgroundColor: thirdColor,
                        foregroundColor: secondaryColor,
                      ),
                      icon: const Icon(Icons.how_to_reg_rounded),
                      label: const Text("Register"),
                    ),
                    const SizedBox(width: 20), // Space between buttons
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(140, 60),
                        backgroundColor: thirdColor,
                        foregroundColor: secondaryColor,
                      ),
                      icon: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: secondaryColor,
                              ),
                            )
                          : const Icon(Icons.login_sharp),
                      label: _isLoading
                          ? const SizedBox.shrink() // Hide label while loading
                          : const Text("Login"),
                    ),
                  ],
                ),
                const SizedBox(height: 35),
                if (errorMessage != null)
                  Center(
                    child: Text(
                      errorMessage!,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const Color mainColor = Color(0xff6a6446);
const Color secondaryColor = Color(0xfff2f0e4);
const Color thirdColor = Color(0xff403a1f);
const Color fourthColor = Color(0xffbf7d2c);
