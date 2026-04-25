import 'package:commitlock/features/commitment/data/model/commitment_model.dart';
import 'package:hive/hive.dart';

class HistoryLocalDataSource {
  final Box<CommitmentModel> box;

  HistoryLocalDataSource(this.box);

  List<CommitmentModel> getAllHistory() {
    return box.values.toList();
  }

  List<CommitmentModel> getCompleted() {
    return box.values.where((e) => e.isCompleted == true).toList();
  }

  List<CommitmentModel> getBroken() {
    return box.values
        .where((e) => e.isActive == false && e.isCompleted == false)
        .toList();
  }
}
