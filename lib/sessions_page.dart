import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'models/audio_session.dart';
import 'session_data.dart';

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
        codec: Codec.aacADTS, // Match the recorded codec
        whenFinished: () {
          debugPrint('Playback finished.');
        },
      );
      debugPrint('Playing: $path');
    } catch (e) {
      debugPrint('Error playing audio: $e');
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
      appBar: AppBar(title: Text('Sessions')),
      body: ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          return ListTile(
            title: Text(session.name),
            subtitle: Text(session.createdAt.toLocal().toString()),
            trailing: IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: () => _playAudio(session.filePath),
            ),
          );
        },
      ),
    );
  }
}
