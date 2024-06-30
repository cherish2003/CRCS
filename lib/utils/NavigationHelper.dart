import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class NavigationHelper {
  static Future<void> navigateTo(
      BuildContext context, Widget destination) async {
    if (await _checkTokenExpiry(context)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
    }
  }

  static Future<bool> _checkTokenExpiry(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("Token");

    if (token != null) {
      bool isTokenExpired = JwtDecoder.isExpired(token);

      if (isTokenExpired) {
        await prefs.remove("Token");
        Navigator.pushReplacementNamed(context, '/login');
        return false;
      }
    }
    return true;
  }
}
