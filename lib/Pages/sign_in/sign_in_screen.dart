import 'package:flutter/material.dart';
import 'package:crcs/Pages/sign_in/components/Register_user.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});



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
                  "Welcome ",
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
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(140, 60),
                        backgroundColor: thirdColor,
                        foregroundColor: secondaryColor,
                      ),
                      icon: const Icon(Icons.login_sharp),
                      label: const Text("Login"),
                    ),
                  ],
                ),
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
