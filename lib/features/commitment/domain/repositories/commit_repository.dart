import 'package:commitlock/features/commitment/data/model/commitment_model.dart';

abstract class CommitmentRepository {
  Future<void> startCommitment(CommitmentModel model);

  Future<List<CommitmentModel>> fetchAll();

  Future<void> updateCommitment(CommitmentModel model);

  Future<void> clearAll();

  Future<CommitmentModel?> getSessionById(String id);
  Future<CommitmentModel?> getActiveSession();
}
