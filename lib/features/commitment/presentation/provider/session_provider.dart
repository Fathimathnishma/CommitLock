import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/model/commitment_model.dart';
import '../../domain/repositories/commit_repository.dart';

enum SessionStatus { idle, running, completed, broken }

class SessionProvider extends ChangeNotifier {
  final CommitmentRepository repository;

  SessionProvider(this.repository);

  CommitmentModel? activeSession;

  Timer? _timer;

  Duration remainingDuration = Duration.zero;
  double progress = 0.0;

  SessionStatus status = SessionStatus.idle;

  String currentQuote = "Discipline beats motivation.";

  Future<void> loadSession(String sessionId) async {
    activeSession = await repository.getSessionById(sessionId);

    if (activeSession == null) return;

    final start = activeSession!.startTime;
    final duration = Duration(minutes: activeSession!.plannedDuration);
    final endTime = start.add(duration);

    if (DateTime.now().isAfter(endTime)) {
      await _completeSession();
      return;
    }

    status = SessionStatus.running;
    _startTimer();
  }

  void reset() {
    activeSession = null;
    status = SessionStatus.idle;
    progress = 0;
    remainingDuration = Duration.zero;
    notifyListeners();
  }

  Future<void> loadActiveSession() async {
    activeSession = await repository.getActiveSession();

    if (activeSession == null) return;

    final start = activeSession!.startTime;
    final duration = Duration(minutes: activeSession!.plannedDuration);
    final endTime = start.add(duration);

    if (activeSession!.isActive) {
      if (DateTime.now().isAfter(endTime)) {
        await _completeSession();
      } else {
        status = SessionStatus.running;
        _startTimer();
      }
    } else {
      status = activeSession!.isCompleted
          ? SessionStatus.completed
          : SessionStatus.broken;
      notifyListeners();
    }
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculate();
    });

    _calculate();
  }

  void _calculate() {
    if (activeSession == null || status != SessionStatus.running) return;

    final start = activeSession!.startTime;
    final duration = Duration(minutes: activeSession!.plannedDuration);
    final endTime = start.add(duration);

    final diff = endTime.difference(DateTime.now());

    remainingDuration = diff.isNegative ? Duration.zero : diff;

    final total = duration.inSeconds;
    final remain = remainingDuration.inSeconds;

    progress = total == 0 ? 1.0 : 1 - (remain / total);

    if (remainingDuration.inSeconds <= 0) {
      _completeSession();
      return;
    }

    notifyListeners();
  }

  int _calculateActualMinutes() {
    final start = activeSession!.startTime;
    return DateTime.now().difference(start).inMinutes;
  }

  Future<void> _completeSession() async {
    if (activeSession == null) return;

    status = SessionStatus.completed;
    _timer?.cancel();

    activeSession!
      ..actualDuration = _calculateActualMinutes()
      ..isCompleted = true
      ..isActive = false
      ..endTime = DateTime.now();

    await repository.updateCommitment(activeSession!);

    notifyListeners();
  }

  Future<void> markBroken() async {
    if (activeSession == null) return;

    status = SessionStatus.broken;
    _timer?.cancel();

    activeSession!
      ..actualDuration = _calculateActualMinutes()
      ..isCompleted = false
      ..isActive = false
      ..endTime = DateTime.now();

    await repository.updateCommitment(activeSession!);

    notifyListeners();
  }

  String format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
