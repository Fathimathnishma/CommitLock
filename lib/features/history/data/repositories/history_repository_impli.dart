import 'package:commitlock/features/commitment/data/model/commitment_model.dart';
import 'package:commitlock/features/history/data/data_sourse/history_local_datasource.dart';
import 'package:commitlock/features/history/domain/repositories/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryLocalDataSource local;

  HistoryRepositoryImpl(this.local);

  @override
  List<CommitmentModel> getAll() {
    return local.getAllHistory();
  }

  @override
  List<CommitmentModel> getCompleted() {
    return local.getCompleted();
  }

  @override
  List<CommitmentModel> getBroken() {
    return local.getBroken();
  }
}
