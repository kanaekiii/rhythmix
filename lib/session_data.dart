// session_data.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/audio_session.dart';

class SessionData {
  static List<AudioSession> sessions = [];

  static Future<void> saveSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = sessions.map((s) => jsonEncode(s.toJson())).toList();
    await prefs.setStringList('sessions', jsonList);
  }

  static Future<void> loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('sessions') ?? [];
    sessions = jsonList.map((s) => AudioSession.fromJson(jsonDecode(s))).toList();
  }
}
