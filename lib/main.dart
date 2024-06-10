import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crcs/Pages/home.dart';
import 'package:crcs/Pages/student_page/Context/student_data_context.dart';
import 'package:crcs/components/storeKeyandIV.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  storeKeyAndIV();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StudentDataContext()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white),
              foregroundColor: Colors.white),
        ),
        home: const HomePage(),
      ),
    );
  }
}
