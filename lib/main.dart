import 'package:flutter/material.dart';
import 'home_page.dart';
import 'session_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required before using async features
  await SessionData.loadSessions(); // Load saved sessions from local storage
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
