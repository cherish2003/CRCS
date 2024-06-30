// token_manager.dart

import 'package:crcs/Pages/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static Future<bool> isTokenExpired() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? expirationDateString = prefs.getString('token_expiration');

    if (expirationDateString == null) {
      return true;
    }

    DateTime expirationDate = DateTime.parse(expirationDateString);
    return DateTime.now().isAfter(expirationDate);
  }

  static Future<void> logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('token_expiration');
    await prefs.remove('refresh_token');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  static Future<void> checkTokenExpiration(BuildContext context) async {
    if (await isTokenExpired()) {
      logout(context);
    }
  }
}
