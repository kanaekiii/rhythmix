import 'package:flutter/material.dart';
import 'metronome_page.dart';

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
      // App bar with logo/name
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

      // Body with feature cards and 'Start a new session' button
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                children: [
                  // Metronome card
                  _buildFeatureCard(
                    context,
                    'Metronome',
                    'Set your rhythm',
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MetronomePage()),
                    ),
                  ),

                  // Pitch Detection card
                  _buildFeatureCard(
                    context,
                    'Pitch Detection',
                    'Tune your notes',
                        () {}
                  ),

                  // Sessions & Notes in a row
                  Row(
                    children: [
                      Expanded(
                        child: _buildFeatureCard(
                          context,
                          'Sessions',
                          'Track your progress',
                              () {},
                          small: true,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildFeatureCard(
                          context,
                          'Notes',
                          'Record your ideas',
                              () {},
                          small: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Start a new session button
            ElevatedButton(
              onPressed: () {
                // Example navigation or logic
                // Navigator.push(context, MaterialPageRoute(builder: (context) => SessionPage()));
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

      // Bottom nav bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Sessions'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),

        ],
      ),
    );
  }
}
