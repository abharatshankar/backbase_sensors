import 'package:backbase_sesnosr_app/app/app.dart';
import 'package:backbase_sesnosr_app/app/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Device Info & Sensors',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home:  App(),
      debugShowCheckedModeBanner: false,
    );
  }
}