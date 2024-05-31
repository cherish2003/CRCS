import 'dart:async';
import 'dart:convert';

import 'package:crcs/Pages/FacultyMentor/Facultymentornavigation.dart';
import 'package:crcs/Pages/sign_in/components/Get_deviceinfo.dart';
import 'package:crcs/Pages/student_page/StudentHomepage.dart';
import 'package:crcs/Pages/student_page/StudentNavigationPage.dart';
import 'package:crcs/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:crcs/config.dart';
import 'package:http/http.dart' as http;

class RegisterUser extends StatefulWidget {
  const RegisterUser({Key? key}) : super(key: key);

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  String? userRole;
  String? stateId;

  final _formKey = GlobalKey<FormState>(); // Add form key

  List<dynamic> Roles = [];
  List<dynamic> FormValues = [];
  List<dynamic> states = [];
  Map<String, dynamic>? deviceInfo;
  String? errorMessage;
  String? sucessMessage;
  bool loadingState = false;

  Future signinClick() async {
    setState(() {
      loadingState = true; // Set loading state to true when registration starts
      errorMessage = null; // Clear any previous error messages
    });
    // Retrieve input field data
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
    // Get device information
    final info = await getDeviceInfo();
    setState(() {
      deviceInfo = info;
    });

    var regBody = {
      "UserRole": selectedRoleLabel,
      "InputInfo": formData,
      "deviceInfo": deviceInfo
    };

    try {
      var response = await http.post(Uri.parse(register),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var responseData = jsonDecode(response.body);
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (responseData['success']) {
        var token = responseData['token'];
        if (selectedRoleLabel == "Student") {
          var rollno = responseData['userData']['rollno'];
          var batch = responseData['userData']['batch'];
          prefs.setString("Token", token);
          prefs.setString("Rollno", rollno);
          prefs.setString("Batch", batch);
          print(token);

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => StudentNavigationPage()));
        }
        if (selectedRoleLabel == "Faculty mentor") {
          prefs.setString("Token", token);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Facultymentornavigation()));
        }
        prefs.setString("Token", token);
        //to navigate 
      } else {
        setState(() {
          errorMessage = responseData['error'];
        });
      }
    } catch (e) {
      setState(() {
        errorMessage =
            "Failed to register. Please try again later."; // Display a generic error message
      });
    } finally {
      setState(() {
        loadingState =
            false; // Set loading state to false when registration completes
      });
    }
    // print(response.body);
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
      {"id": 1, "label": "Student full name", "ParentId": 1},
      {"id": 2, "label": "College mail", "ParentId": 1},
      {"id": 3, "label": "Student Roll number", "ParentId": 1},
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
                const SizedBox(width: 20, height: 10),
                const Text(
                  "Note : Your device info will be captured once you are registered it cannot be undone !! ",
                  style: TextStyle(color: redColor),
                ),
                const SizedBox(width: 20, height: 20),
                ElevatedButton.icon(
                  onPressed: loadingState
                      ? null // Disable button while loading
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
                          // Display loading indicator if loading
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
                  Text(
                    errorMessage!,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getFormFieldsForRole(String role) {
    List<Widget> formFields = [];

    for (var formValue in FormValues) {
      if (formValue['ParentId'] == int.parse(role)) {
        formFields.add(
          Padding(
            padding:
                EdgeInsets.symmetric(vertical: 16), // Add space between fields
            child: TextFormField(
              controller: controllers[formValue['label']],
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
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 14),
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
                  return 'Input required !!!';
                }
                if ((formValue['label'] == 'Student full name' ||
                        formValue['label'] == 'Parent full name' ||
                        formValue['label'] == 'Faculty mentor name' ||
                        formValue['label'] == 'Faculty coordinator name') &&
                    !isValidName(value)) {
                  return "Name should contain only alphabets !!";
                }
                if (formValue['label'] == 'Student Roll number') {
                  if (!RegExp(r'^AP\d{11}$').hasMatch(value)) {
                    return 'Invalid format. Format should be like APXXXXXXXXXXX';
                  }
                } else if (formValue['label'] == 'College mail') {
                  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@srmap\.edu\.in$')
                      .hasMatch(value)) {
                    return 'Required email format example@srmap.edu.in !!!';
                  }
                }
                return null;
              },
            ),
          ),
        );
      }
    }

    return formFields;
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
