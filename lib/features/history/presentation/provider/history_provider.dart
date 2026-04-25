import 'package:flutter/material.dart';
import 'package:commitlock/features/commitment/data/model/commitment_model.dart';
import 'package:commitlock/features/commitment/domain/repositories/commit_repository.dart';

class HistoryProvider extends ChangeNotifier {
  final CommitmentRepository repository;

  HistoryProvider(this.repository);

  String selectedTab = "All";
  String sort = "Newest";

  List<CommitmentModel> sessions = [];

  Future<void> loadSessions() async {
    sessions = await repository.fetchAll();
    notifyListeners();
  }

  void changeTab(String value) {
    selectedTab = value;
    notifyListeners();
  }

  void changeSort(String value) {
    sort = value;
    notifyListeners();
  }

  int get total => sessions.length;

  int get completed => sessions.where((s) => s.isCompleted == true).length;

  int get totalMinutes => sessions.fold(0, (sum, s) => sum + s.plannedDuration);

  double get successRate => total == 0 ? 0 : (completed / total) * 100;

  List<CommitmentModel> get filteredList {
    List<CommitmentModel> data = List.from(sessions);

    if (selectedTab == "Completed") {
      data = data.where((e) => e.isCompleted).toList();
    } else if (selectedTab == "Broken") {
      data = data.where((e) => !e.isCompleted).toList();
    }

    data.sort((a, b) {
      if (sort == "Newest") {
        return b.createdAt.compareTo(a.createdAt);
      } else {
        return a.createdAt.compareTo(b.createdAt);
      }
    });

    return data;
  }

  Future<void> clearHistory() async {
    await repository.clearAll();
    await loadSessions();
  }
}
