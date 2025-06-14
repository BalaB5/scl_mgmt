import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'modules/dashboard/views/screens/landing_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: LandingScreen(),
    );
  }
}
