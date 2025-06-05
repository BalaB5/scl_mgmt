import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'modules/student/views/screens/stundents_list.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: StudentsListPage(),
    );
  }
}
