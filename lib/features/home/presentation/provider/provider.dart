import 'package:commitlock/features/commitment/data/model/commitment_model.dart';
import 'package:commitlock/features/commitment/domain/repositories/commit_repository.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  final CommitmentRepository repository;

  HomeProvider(this.repository);

  List<CommitmentModel> allSessions = [];

  Future<void> load() async {
    allSessions = await repository.fetchAll();
    notifyListeners();
  }

  List<CommitmentModel> get todaySessions {
    final now = DateTime.now();
    return allSessions.where((s) {
      return s.createdAt.year == now.year &&
          s.createdAt.month == now.month &&
          s.createdAt.day == now.day;
    }).toList();
  }

  int get todayCommitted =>
      todaySessions.fold(0, (sum, s) => sum + s.plannedDuration);

  int get todayCompleted =>
      todaySessions.fold(0, (sum, s) => sum + (s.actualDuration ?? 0));

  double get progress {
    if (todayCommitted == 0) return 0;
    return (todayCompleted / todayCommitted).clamp(0.0, 1.0);
  }

  CommitmentModel? get activeSession {
    final list = allSessions.where((s) => s.isActive).toList();
    return list.isEmpty ? null : list.first;
  }

  int get streak {
    if (allSessions.isEmpty) return 0;

    final grouped = <String, List<CommitmentModel>>{};

    for (var s in allSessions) {
      final key = "${s.createdAt.year}-${s.createdAt.month}-${s.createdAt.day}";
      grouped.putIfAbsent(key, () => []).add(s);
    }

    final days = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    int count = 0;

    for (var day in days) {
      final sessions = grouped[day]!;

      final allCompleted = sessions.every((s) => s.isCompleted == true);

      if (allCompleted) {
        count++;
      } else {
        break;
      }
    }

    return count;
  }
}
