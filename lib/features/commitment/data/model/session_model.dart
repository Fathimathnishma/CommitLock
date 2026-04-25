class SessionModel {
  final String category;
  final Duration duration;
  final DateTime startTime;
  final String restriction;
  final int penalty;

  SessionModel({
    required this.category,
    required this.duration,
    required this.startTime,
    required this.restriction,
    required this.penalty,
  });
}
