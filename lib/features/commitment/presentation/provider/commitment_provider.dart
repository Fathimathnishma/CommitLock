import 'package:commitlock/features/commitment/data/model/commitment_model.dart';
import 'package:commitlock/features/commitment/domain/repositories/commit_repository.dart';
import 'package:flutter/material.dart';

class NewCommitmentProvider extends ChangeNotifier {
  final CommitmentRepository repository;

  NewCommitmentProvider(this.repository);

  bool isLoading = false;

  String selectedCategory = "Reading";

  final List<String> categories = [
    "Reading",
    "Exercise",
    "Language Study",
    "Coding Practice",
    "Meditation",
    "Custom",
  ];

  String customCategory = "";

  int selectedDuration = 30;
  int? customDuration;

  final List<int> durations = [15, 30, 45, 60, 90];

  final TextEditingController penaltyController = TextEditingController();

  String restriction = "Normal";

  Map<String, bool> blockedApps = {
    "Social Media": false,
    "Video Streaming": false,
    "Games": false,
    "News": false,
  };

  bool get isCustomDuration => selectedDuration == -1;

  int get finalDuration =>
      isCustomDuration ? (customDuration ?? 0) : selectedDuration;

  bool get isFormValid {
    final penalty = int.tryParse(penaltyController.text.trim());

    if (selectedCategory == "Custom" && customCategory.trim().isEmpty) {
      return false;
    }

    if (penalty == null || penalty <= 0) {
      return false;
    }

    if (finalDuration <= 0) {
      return false;
    }

    return true;
  }

  String? validateForm() {
    final penalty = int.tryParse(penaltyController.text.trim());

    if (selectedCategory == "Custom" && customCategory.trim().isEmpty) {
      return "Custom category cannot be empty";
    }

    if (penalty == null || penalty <= 0) {
      return "Penalty must be greater than 0";
    }

    if (finalDuration <= 0) {
      return "Select a valid duration";
    }

    return null;
  }

  void selectCategory(String value) {
    selectedCategory = value;
    notifyListeners();
  }

  void setCustomCategory(String value) {
    customCategory = value;
    notifyListeners();
  }

  void selectDuration(int value) {
    selectedDuration = value;
    if (value != -1) customDuration = null;
    notifyListeners();
  }

  void setCustomDuration(int value) {
    customDuration = value;
    notifyListeners();
  }

  void setRestriction(String value) {
    restriction = value;
    notifyListeners();
  }

  void toggleBlocked(String key, bool value) {
    blockedApps[key] = value;
    notifyListeners();
  }

  Future<String?> createCommitment() async {
    if (isLoading) return null;

    isLoading = true;
    notifyListeners();

    try {
      final finalCategory = selectedCategory == "Custom"
          ? (customCategory.trim().isEmpty ? "Custom" : customCategory.trim())
          : selectedCategory;

      final model = CommitmentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        category: finalCategory,
        plannedDuration: finalDuration,
        actualDuration: 0,
        penaltyAmount: int.tryParse(penaltyController.text.trim()) ?? 0,
        restrictionLevel: restriction,
        blockedCategories: blockedApps.entries
            .where((e) => e.value)
            .map((e) => e.key)
            .toList(),
        startTime: DateTime.now(),
        endTime: null,
        isCompleted: false,
        isActive: true,
        createdAt: DateTime.now(),
      );

      await repository.startCommitment(model);

      final id = model.id;

      resetForm();

      return id;
    } catch (e) {
      debugPrint("Commitment creation failed: $e");
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void resetForm() {
    selectedCategory = "Reading";
    customCategory = "";
    selectedDuration = 30;
    customDuration = null;
    restriction = "Normal";
    penaltyController.clear();
    blockedApps.updateAll((key, value) => false);
    notifyListeners();
  }

  @override
  void dispose() {
    penaltyController.dispose();
    super.dispose();
  }
}
