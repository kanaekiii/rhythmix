// ignore_for_file: unused_import

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'models/audio_session.dart';
import 'session_data.dart';

class AudioRecorderPage extends StatefulWidget {
  final String sessionName;

  const AudioRecorderPage({super.key, required this.sessionName});

  @override
  State<AudioRecorderPage> createState() => _AudioRecorderPageState();
}

class _AudioRecorderPageState extends State<AudioRecorderPage> with SingleTickerProviderStateMixin {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String? _filePath;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _init();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _init() async {
    await Permission.microphone.request();
    await _recorder.openRecorder();
  }

  Future<void> _startRecording() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/${widget.sessionName}_${DateTime.now().millisecondsSinceEpoch}.aac';
    await _recorder.startRecorder(toFile: path);
    setState(() {
      _isRecording = true;
      _filePath = path;
    });
  }

  Future<void> _pauseResumeRecording() async {
    if (_recorder.isPaused) {
      await _recorder.resumeRecorder();
    } else {
      await _recorder.pauseRecorder();
    }
    setState(() {}); // Refresh UI icon
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() => _isRecording = false);

    if (_filePath != null) {
      final newSession = AudioSession(
        name: widget.sessionName,
        filePath: _filePath!,
        createdAt: DateTime.now(),
      );

      SessionData.sessions.add(newSession);
      await SessionData.saveSessions();

      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: widget.sessionName.substring(0, widget.sessionName.length ~/ 2),
              ),
              TextSpan(
                text: widget.sessionName.substring(widget.sessionName.length ~/ 2),
                style: const TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isRecording)
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.mic, size: 40, color: Colors.white),
                    ),
                  );
                },
              )
            else
              const Icon(Icons.mic_none, size: 100, color: Colors.grey),

            const SizedBox(height: 40),

            if (_isRecording)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 45,
                    icon: Icon(
                      _recorder.isPaused ? Icons.play_arrow : Icons.pause,
                      color: Colors.blue,
                    ),
                    onPressed: _pauseResumeRecording,
                  ),
                  const SizedBox(width: 30),
                  ElevatedButton.icon(
                    onPressed: _stopRecording,
                    icon: const Icon(Icons.stop),
                    label: const Text("Stop"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                    ),
                  ),
                ],
              )
            else
              ElevatedButton.icon(
                onPressed: _startRecording,
                icon: const Icon(Icons.fiber_manual_record),
                label: const Text("Start Recording"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
