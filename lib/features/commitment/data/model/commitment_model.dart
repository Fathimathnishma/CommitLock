import 'package:hive/hive.dart';

part 'commitment_model.g.dart';

@HiveType(typeId: 0)
class CommitmentModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final int plannedDuration;

  @HiveField(3)
  int? actualDuration;

  @HiveField(4)
  final int penaltyAmount;

  @HiveField(5)
  final String restrictionLevel;

  @HiveField(6)
  final List<String> blockedCategories;

  @HiveField(7)
  final DateTime startTime;

  @HiveField(8)
  DateTime? endTime;

  @HiveField(9)
  bool isCompleted;

  @HiveField(10)
  bool isActive;

  @HiveField(11)
  final DateTime createdAt;

  CommitmentModel({
    required this.id,
    required this.category,
    required this.plannedDuration,
    this.actualDuration,
    required this.penaltyAmount,
    required this.restrictionLevel,
    required this.blockedCategories,
    required this.startTime,
    this.endTime,
    this.isCompleted = false,
    this.isActive = true,
    required this.createdAt,
  });
}


//////////////////////


