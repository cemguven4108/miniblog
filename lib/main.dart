import 'package:flutter/material.dart';
import 'package:miniblog/screens/home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const HomeScreen(),
    ),
  );
}