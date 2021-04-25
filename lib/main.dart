import 'package:flutter/material.dart';
import 'widgets/NavigationBar.dart';

void main() {
  runApp(RosebudApp());
}

class RosebudApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NavigationBar(),
    );
  }
}








