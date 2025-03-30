import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const RhythmixApp());
}

class RhythmixApp extends StatelessWidget {
  const RhythmixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rhythmix',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
