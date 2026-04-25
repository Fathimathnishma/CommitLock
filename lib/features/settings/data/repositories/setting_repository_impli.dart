import 'package:commitlock/features/settings/data/data_source/setting_localsource.dart';
import 'package:commitlock/features/settings/domain/repositories/setting_repository.dart';
import 'package:flutter/material.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource local;

  SettingsRepositoryImpl(this.local);

  // ---------------- THEME ----------------

  @override
  ThemeMode getTheme() {
    final value = local.getTheme();

    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  @override
  Future<void> saveTheme(ThemeMode mode) {
    return local.setTheme(mode.name);
  }

  // ---------------- SOUND ----------------

  @override
  bool getSound() => local.getSound();

  @override
  Future<void> saveSound(bool value) => local.setSound(value);

  // ---------------- NOTIFY ----------------

  @override
  bool getNotify() => local.getNotify();

  @override
  Future<void> saveNotify(bool value) => local.setNotify(value);

  // ---------------- APPS ----------------

  @override
  Map<String, bool> getBlockedApps() {
    final raw = local.getApps();
    return Map<String, bool>.from(raw);
  }

  @override
  Future<void> saveBlockedApps(Map<String, bool> apps) {
    return local.setApps(apps);
  }
}
