import 'package:commitlock/features/commitment/data/model/commitment_model.dart';

abstract class HistoryRepository {
  List<CommitmentModel> getAll();
  List<CommitmentModel> getCompleted();
  List<CommitmentModel> getBroken();
}
