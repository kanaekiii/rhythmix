import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MetronomePage extends StatefulWidget {
  @override
  _MetronomePageState createState() => _MetronomePageState();
}

class _MetronomePageState extends State<MetronomePage>
    with SingleTickerProviderStateMixin {
  int bpm = 120;
  int beatsPerMeasure = 4;
  bool isPlaying = false;
  late Timer _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeOut,
      ),
    );

    _pulseController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _pulseController.reverse();
      }
    });
  }

  void _startMetronome() {
    final interval = Duration(milliseconds: (60000 / bpm).round());
    _timer = Timer.periodic(interval, (_) async {
      await _audioPlayer.play(
        AssetSource('tick.wav'),
        volume: 1.0, // maximum volume
      );

      if (_pulseController.isAnimating) {
        _pulseController.stop();
      }
      _pulseController.forward(from: 0.0);
    });

    setState(() {
      isPlaying = true;
    });
  }

  void _stopMetronome() {
    _timer.cancel();
    setState(() {
      isPlaying = false;
    });
  }

  void _toggleMetronome() {
    if (isPlaying) {
      _stopMetronome();
    } else {
      _startMetronome();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    if (_timer.isActive) _timer.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF6FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: RichText(
          text: const TextSpan(
            text: 'Metro',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: 'nome',
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.lightBlueAccent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.6),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$bpm BPM',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => setState(() {
                    bpm = (bpm - 1).clamp(40, 300);
                  }),
                ),
                Slider(
                  value: bpm.toDouble(),
                  min: 40,
                  max: 300,
                  activeColor: Colors.blue,
                  onChanged: (value) {
                    setState(() {
                      bpm = value.round();
                      if (isPlaying) {
                        _stopMetronome();
                        _startMetronome();
                      }
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => setState(() {
                    bpm = (bpm + 1).clamp(40, 300);
                  }),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _circleButton("-", () {
                  setState(() {
                    beatsPerMeasure = (beatsPerMeasure - 1).clamp(1, 12);
                  });
                }),
                const SizedBox(width: 20),
                Text(
                  "$beatsPerMeasure",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 20),
                _circleButton("+", () {
                  setState(() {
                    beatsPerMeasure = (beatsPerMeasure + 1).clamp(1, 12);
                  });
                }),
              ],
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: _toggleMetronome,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Icon(
                  isPlaying ? Icons.stop : Icons.play_arrow,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(fontSize: 20),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlueAccent,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        elevation: 4,
      ),
    );
  }
}
