// models/audio_session.dart

class AudioSession {
  final String name;
  final String filePath;
  final DateTime createdAt;

  AudioSession({
    required this.name,
    required this.filePath,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'filePath': filePath,
    'createdAt': createdAt.toIso8601String(),
  };

  factory AudioSession.fromJson(Map<String, dynamic> json) => AudioSession(
    name: json['name'],
    filePath: json['filePath'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}
