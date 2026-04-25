import 'package:hive/hive.dart';
import 'package:commitlock/features/commitment/data/model/commitment_model.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.openBox<CommitmentModel>('commitments');
    await Hive.openBox('auth');
    await Hive.openBox('settings');
  }

  static Box<CommitmentModel> commitmentBox() =>
      Hive.box<CommitmentModel>('commitments');

  static Box authBox() => Hive.box('auth');

  static Box settingsBox() => Hive.box('settings');
}
