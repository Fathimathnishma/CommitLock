import 'package:commitlock/features/commitment/data/data_sources/commitment_local_datasources.dart';
import 'package:commitlock/features/commitment/data/model/commitment_model.dart';
import 'package:commitlock/features/commitment/domain/repositories/commit_repository.dart';

class CommitmentRepositoryImpl implements CommitmentRepository {
  final CommitmentLocalDataSource local;

  CommitmentRepositoryImpl(this.local);

  @override
  Future<void> startCommitment(CommitmentModel model) async {
    await local.addCommitment(model);
  }

  @override
  Future<List<CommitmentModel>> fetchAll() async {
    return local.getAll();
  }

  @override
  Future<void> updateCommitment(CommitmentModel model) async {
    await local.updateCommitment(model);
  }

  @override
  Future<void> clearAll() async {
    await local.deleteAll();
  }

  @override
  Future<CommitmentModel?> getSessionById(String id) async {
    return local.getById(id);
  }

  @override
  Future<CommitmentModel?> getActiveSession() async {
    final all = local.getAll();

    try {
      return all.firstWhere((e) => e.isActive == true);
    } catch (_) {
      return null;
    }
  }
}
