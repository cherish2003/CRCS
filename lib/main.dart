import 'package:crcs/Pages/home.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            foregroundColor: Colors.white),
      ),
      home: const HomePage(),
    );
  }
}
