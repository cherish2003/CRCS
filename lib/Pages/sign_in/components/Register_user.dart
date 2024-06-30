import 'dart:async';
import 'dart:convert';

import 'package:crcs/Pages/FacultyCoor/FacultyCoorNavig.dart';
import 'package:crcs/Pages/sign_in/components/Get_deviceinfo.dart';
import 'package:crcs/Pages/student_page/StudentHomepage.dart';
import 'package:crcs/constants.dart';
import 'package:crcs/utils/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:crcs/api/config.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:math';

String generateRandomIV() {
  final random = Random.secure();
  final ivBytes = List<int>.generate(16, (_) => random.nextInt(256));
  return String.fromCharCodes(ivBytes);
}

class RegisterUser extends StatefulWidget {
  const RegisterUser({Key? key}) : super(key: key);

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

Future<String> encryptDeviceInfo(String deviceInfo) async {
  final storage = FlutterSecureStorage();
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

class _RegisterUserState extends State<RegisterUser> {
  String? userRole;
  String? stateId;

  final _formKey = GlobalKey<FormState>();
  List<dynamic> Roles = [];
  List<dynamic> FormValues = [];
  List<dynamic> states = [];
  Map<String, dynamic>? deviceInfo;
  String? errorMessage;
  String? sucessMessage;
  String? Studentemail;
  String? StudentrollNumber;
  bool loadingState = false;
  bool googleloadingState = false;
  bool isGoogleAuthDone = false;

  Future<void> signInwithGoogle() async {
    final user = await GoogleSignInApi.login();
    print(user);

    if (user != null) {
      String? displayName = user.displayName;
      String? email = user.email;

      String? rollNumber;
      if (displayName != null) {
        rollNumber = RegExp(r'AP\d{11}').stringMatch(displayName);
      }

      if (email == null ||
          !RegExp(r'^[a-zA-Z0-9._%+-]+@srmap\.edu\.in$').hasMatch(email)) {
        setState(() {
          errorMessage = 'Collega mail is required for registration !!!';
        });
        await GoogleSignInApi.logout();
        return;
      }

      if (rollNumber == null || !RegExp(r'^AP\d{11}$').hasMatch(rollNumber)) {
        setState(() {
          errorMessage = 'Invalid format. Format should be like APXXXXXXXXXXX';
        });
        await GoogleSignInApi.logout();
        return;
      }

      setState(() {
        Studentemail = email;
        StudentrollNumber = rollNumber;
        isGoogleAuthDone = true;
        errorMessage = null;
      });
    }
  }

  Future signinClick() async {
    if (userRole == '1' && !isGoogleAuthDone) {
      setState(() {
        errorMessage = "Registration with google must be done first !!";
      });
      return;
    }
    setState(() {
      loadingState = true;
      errorMessage = null;
    });

    Map<String, dynamic> formData = {};
    for (var formValue in FormValues) {
      String label = formValue['label'];
      if (formValue['ParentId'] == int.parse(userRole!)) {
        formData[label] = controllers[label]!.text;
      }
    }

    String selectedRoleLabel = "";
    for (var role in Roles) {
      if (role['id'] == int.parse(userRole!)) {
        selectedRoleLabel = role['label'];
        break;
      }
    }
    print("Selected Role: $selectedRoleLabel");

    final info = await getDeviceInfo();
    final encryptedDeviceInfo = await encryptDeviceInfo(jsonEncode(info));
    print('Encrypted Device Info: $encryptedDeviceInfo');

    Map<String, dynamic> StudentData = {
      "Student Roll number": StudentrollNumber,
      "College mail": Studentemail,
    };
    var regBody = {
      "UserRole": selectedRoleLabel,
      "InputInfo": selectedRoleLabel == "Student" ? StudentData : formData,
      "encryptedDeviceInfo": encryptedDeviceInfo
    };

    try {
      var response = await http.post(
        Uri.parse(register),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      var responseData = jsonDecode(response.body);
      print("Response Data: $responseData");
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (responseData['success'] == true) {
        var userData = responseData['userData'];

        if (userData != null) {
          var token = responseData['token'];
          print("Token: $token");

          if (selectedRoleLabel == "Student") {
            var rollno = userData['rollno'];
            var batch = userData['yearofpassing'];
            print("Rollno: $rollno");
            print("Batch: $batch");

            // Ensure token, rollno, and batch are not null before saving
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
          } else if (selectedRoleLabel == "Faculty coordinator") {
            print("User Data: $userData");

            if (token != null) {
              prefs.setString("Token", token);
            } else {
              print("Token is null");
            }
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FacultyCoorNavig()),
            );
          }
        } else {
          print("User data is null");
        }
      } else {
        setState(() {
          errorMessage = responseData['error'];
        });
      }
    } catch (error) {
      print("Error: $error");
      setState(() {
        errorMessage = "An error occurred. Please try again.";
      });
    } finally {
      setState(() {
        loadingState = false;
      });
    }
  }

  late Map<String, TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    Roles = [
      {"id": 1, "label": 'Student'},
      {"id": 2, "label": 'Parent'},
      {"id": 3, "label": 'Faculty mentor'},
      {"id": 4, "label": 'Faculty coordinator'},
    ];
    FormValues = [
      {"id": 1, "label": "Parent full name", "ParentId": 2},
      {"id": 2, "label": "Student full name", "ParentId": 2},
      {"id": 3, "label": "Student Roll number", "ParentId": 2},
      {"id": 1, "label": "Faculty mentor name", "ParentId": 3},
      {"id": 2, "label": "College mail", "ParentId": 3},
      {"id": 1, "label": "Faculty coordinator name", "ParentId": 4},
      {"id": 2, "label": "College mail", "ParentId": 4},
    ];

    // Initialize controllers
    controllers = {};
    for (var formValue in FormValues) {
      controllers[formValue['label']] = TextEditingController();
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Registration"),
          backgroundColor: mainColor,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FormHelper.dropDownWidgetWithLabel(
                  context,
                  "Select Role",
                  "Select Role",
                  userRole,
                  Roles,
                  (onChangedVal) {
                    setState(() {
                      userRole = onChangedVal;
                      print("Selected Role $onChangedVal");
                    });
                  },
                  (onValidate) {
                    if (onValidate == null) {
                      return "Kindly select the role !!";
                    }
                    return null;
                  },
                  labelFontSize: 20,
                  borderColor: thirdColor,
                  borderFocusColor: mainColor,
                  borderRadius: 9,
                  optionLabel: "label",
                  optionValue: "id",
                  prefixIcon: const Icon(Icons.switch_account_rounded),
                  prefixIconColor: mainColor,
                  showPrefixIcon: true,
                  contentPadding: 17,
                  borderWidth: 30,
                ),
                const SizedBox(width: 20, height: 20),
                if (userRole != null) ...getFormFieldsForRole(userRole!),
                if (userRole == '1')
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(250, 50), // Button size
                      side: isGoogleAuthDone
                          ? BorderSide(color: Colors.green)
                          : BorderSide(color: secondaryColor), // Border color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    onPressed: isGoogleAuthDone || googleloadingState
                        ? null
                        : () {
                            setState(() {
                              googleloadingState = true;
                            });
                            signInwithGoogle().then((_) {
                              setState(() {
                                googleloadingState = false;
                              });
                            });
                          },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (googleloadingState)
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: mainColor,
                            ),
                          )
                        else if (isGoogleAuthDone)
                          Icon(Icons.check, color: Colors.green)
                        else
                          Image.asset(
                            'images/google_sign.png', // Ensure you have the Google logo asset in your assets folder
                            height: 24.0,
                          ),
                        SizedBox(width: 10),
                        Text(
                          isGoogleAuthDone
                              ? 'Successfully registered with Google'
                              : 'Register with Google',
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                isGoogleAuthDone ? Colors.green : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(width: 20, height: 10),
                if (userRole == '1')
                  const Text(
                    "Note : \n 1. Students are required to register with Google first.\n 2. After successfully registration, they need to click on Continue to complete the registration process.",
                    style: TextStyle(color: Colors.black),
                  ),
                const SizedBox(width: 20, height: 10),
                const Text(
                  "Note : Your device info will be captured once you are registered it cannot be undone !! ",
                  style: TextStyle(color: redColor),
                ),
                const SizedBox(width: 20, height: 20),
                ElevatedButton.icon(
                  onPressed: loadingState
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            await signinClick();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(140, 60),
                    backgroundColor: thirdColor,
                    foregroundColor: secondaryColor,
                  ),
                  icon: loadingState
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: mainColor,
                          ),
                        )
                      : const Icon(Icons.how_to_reg_outlined),
                  label: loadingState
                      ? SizedBox.shrink() // Hide label while loading
                      : const Text("Continue"),
                ),
                const SizedBox(height: 40),
                if (errorMessage != null)
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      errorMessage!,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    )
                  ]),
                const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getFormFieldsForRole(String role) {
    return FormValues.where(
            (formValue) => formValue['ParentId'] == int.parse(role))
        .map((formValue) {
      String label = formValue['label'];
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: TextFormField(
          controller: controllers[label],
          decoration: InputDecoration(
            labelText: formValue['label'],
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: mainColor, // Specify border color
                width: 10.0, // Specify border width
              ),
              borderRadius:
                  BorderRadius.circular(10.0), // Specify border radius
            ),
            labelStyle: TextStyle(color: thirdColor, fontSize: 18),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: thirdColor, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: mainColor, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              // Specify margin
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
        ),
      );
    }).toList();
  }
}

bool isValidName(String name) {
  final RegExp nameRegExp = RegExp(r'^[a-zA-Z]+$');
  return nameRegExp.hasMatch(name);
}

const Color mainColor = Color(0xff6a6446);
const Color secondaryColor = Color(0xfff2f0e4);
const Color thirdColor = Color(0xff403a1f);
const Color fourthColor = Color(0xffbf7d2c);
