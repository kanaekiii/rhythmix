import 'package:flutter/material.dart';

class MetronomePage extends StatefulWidget {
  const MetronomePage({super.key});

  @override
  _MetronomePageState createState() => _MetronomePageState();
}

class _MetronomePageState extends State<MetronomePage> {
  int _bpm = 120;
  int _beatsPerMeasure = 4;
  bool _isPlaying = false;

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _updateBpm(int newBpm) {
    setState(() {
      _bpm = newBpm;
    });
  }

  void _updateBeatsPerMeasure(int newBeats) {
    setState(() {
      _beatsPerMeasure = newBeats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: const [
            Text('Metro', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
            Text('nome', style: TextStyle(color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Enlarged BPM circle
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.blue.shade300,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$_bpm BPM',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // BPM slider with - and + buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => _updateBpm(_bpm - 1),
                    icon: const Icon(Icons.remove, size: 32),
                  ),
                  Expanded(
                    child: Slider(
                      value: _bpm.toDouble(),
                      min: 40,
                      max: 240,
                      activeColor: Colors.blue,
                      onChanged: (double newValue) {
                        _updateBpm(newValue.round());
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () => _updateBpm(_bpm + 1),
                    icon: const Icon(Icons.add, size: 32),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Beats per measure controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_beatsPerMeasure > 1) {
                        _updateBeatsPerMeasure(_beatsPerMeasure - 1);
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade200),
                    child: const Text('-', style: TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '$_beatsPerMeasure',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => _updateBeatsPerMeasure(_beatsPerMeasure + 1),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade200),
                    child: const Text('+', style: TextStyle(fontSize: 24)),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Play/Pause button with a smaller pause icon
              GestureDetector(
                onTap: _togglePlayPause,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: _isPlaying ? 48 : 64, // Smaller pause icon than play
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
