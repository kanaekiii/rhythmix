import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'models/audio_session.dart';
import 'session_data.dart';
import 'dart:io';

class SessionsPage extends StatefulWidget {
  const SessionsPage({super.key});

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool _isPlayerOpen = false;

  @override
  void initState() {
    super.initState();
    _openPlayer();
  }

  Future<void> _openPlayer() async {
    await _player.openPlayer();
    setState(() => _isPlayerOpen = true);
  }

  Future<void> _playAudio(String path) async {
    if (!_isPlayerOpen) return;
    try {
      await _player.startPlayer(
        fromURI: path,
        codec: Codec.aacADTS,
        whenFinished: () => debugPrint('Playback finished.'),
      );
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  Future<void> _deleteSession(int index) async {
    final session = SessionData.sessions[index];

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Recording"),
        content: Text("Are you sure you want to delete \"${session.name}\"?"),
        actions: [
          TextButton(child: const Text("Cancel"), onPressed: () => Navigator.pop(ctx, false)),
          TextButton(child: const Text("Delete", style: TextStyle(color: Colors.red)), onPressed: () => Navigator.pop(ctx, true)),
        ],
      ),
    );

    if (shouldDelete ?? false) {
      // Delete the file
      final file = File(session.filePath);
      if (await file.exists()) {
        await file.delete();
      }

      // Remove from memory and persist
      setState(() {
        SessionData.sessions.removeAt(index);
      });

      await SessionData.saveSessions();
    }
  }

  @override
  void dispose() {
    _player.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessions = SessionData.sessions;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FF),
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(
            text: 'Sess',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: 'ions',
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: sessions.isEmpty
          ? const Center(child: Text('No sessions recorded yet 💤'))
          : ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: const Icon(Icons.mic, color: Colors.blue),
              title: Text(session.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(session.createdAt.toLocal().toString(), style: const TextStyle(color: Colors.black54)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.play_arrow, color: Colors.blue),
                    onPressed: () => _playAudio(session.filePath),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _deleteSession(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
