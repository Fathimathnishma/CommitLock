import 'package:hive/hive.dart';

class SettingsLocalDataSource {
  final Box box;

  SettingsLocalDataSource(this.box);

  // Theme
  String getTheme() => box.get('theme', defaultValue: 'system');

  Future<void> setTheme(String value) => box.put('theme', value);

  // Sound
  bool getSound() => box.get('sound', defaultValue: true);

  Future<void> setSound(bool value) => box.put('sound', value);

  // Notify
  bool getNotify() => box.get('notify', defaultValue: true);

  Future<void> setNotify(bool value) => box.put('notify', value);

  // Apps
  Map getApps() => box.get('apps', defaultValue: {});

  Future<void> setApps(Map value) => box.put('apps', value);
}
