import 'package:commitlock/features/commitment/data/model/commitment_model.dart';
import 'package:hive/hive.dart';

class CommitmentLocalDataSource {
  final Box<CommitmentModel> box;

  CommitmentLocalDataSource(this.box);

  Future<void> addCommitment(CommitmentModel model) async {
    await box.put(model.id, model);
  }

  List<CommitmentModel> getAll() {
    return box.values.toList();
  }

  Future<CommitmentModel?> getById(String id) async {
    return box.get(id);
  }

  Future<void> updateCommitment(CommitmentModel model) async {
    await box.put(model.id, model);
  }

  Future<void> deleteAll() async {
    await box.clear();
  }

  // 🔥 ADD THIS (CRITICAL)
  CommitmentModel? getActiveSession() {
    try {
      return box.values.firstWhere((e) => e.isActive == true);
    } catch (e) {
      return null;
    }
  }
}
