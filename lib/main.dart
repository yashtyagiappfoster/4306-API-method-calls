import 'package:flutter/material.dart';
import 'package:flutter_rest_api/screens/screen_one.dart';
import 'package:flutter_rest_api/screens/screen_three.dart';
import 'package:flutter_rest_api/screens/screen_two.dart';
import 'package:flutter_rest_api/screens/upload_data_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'APIs',
      home: UploadImageScreen(),
    );
  }
}
