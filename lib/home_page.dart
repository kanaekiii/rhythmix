import 'package:flutter/material.dart';
import 'package:rhythmix_v1/notes_page.dart';
import 'package:rhythmix_v1/pitch_detection_page.dart';
import 'metronome_page.dart';
import 'sessions_page.dart';
import 'audio_recorder_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _buildFeatureCard(
      BuildContext context,
      String title,
      String subtitle,
      VoidCallback onTap, {
        bool small = false,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Container(
          height: small ? 100 : 150,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(subtitle, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.music_note, color: Colors.black),
            Text('RHYTH', style: TextStyle(color: Colors.black)),
            Text('MIX', style: TextStyle(color: Colors.blue)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildFeatureCard(
                    context,
                    'Metronome',
                    'Set your rhythm',
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MetronomePage()),
                    ),
                  ),
                  _buildFeatureCard(
                    context,
                    'Pitch Detection',
                    'Tune your notes',
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TunerPage()),
                      );
                    },
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: _buildFeatureCard(
                          context,
                          'Sessions',
                          'Track your progress',
                              () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SessionsPage()),
                          ),
                          small: true,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildFeatureCard(
                          context,
                          'Notes',
                          'Record your ideas',
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const NotesPage()),
                              ),
                          small: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final sessionNameController = TextEditingController();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Name your session'),
                    content: TextField(
                      controller: sessionNameController,
                      decoration: const InputDecoration(hintText: 'Session Name'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          final name = sessionNameController.text.trim();
                          if (name.isNotEmpty) {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AudioRecorderPage(sessionName: name),
                              ),
                            );
                          }
                        },
                        child: const Text('Continue'),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Start a new session'),
            ),
          ],
        ),
      ),
    );
  }
}
