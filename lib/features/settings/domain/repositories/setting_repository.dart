import 'package:flutter/material.dart';

abstract class SettingsRepository {
  ThemeMode getTheme();
  Future<void> saveTheme(ThemeMode mode);

  bool getSound();
  Future<void> saveSound(bool value);

  bool getNotify();
  Future<void> saveNotify(bool value);

  Map<String, bool> getBlockedApps();
  Future<void> saveBlockedApps(Map<String, bool> apps);
}
