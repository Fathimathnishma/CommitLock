import 'package:commitlock/features/settings/domain/repositories/setting_repository.dart';
import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsRepository repo;

  SettingsProvider(this.repo) {
    _load();
  }

  ThemeMode themeMode = ThemeMode.system;
  bool soundOn = true;
  bool notifyOn = true;

  final List<String> apps = [
    "Instagram",
    "Facebook",
    "TikTok",
    "Snapchat",
    "WhatsApp",
    "PUBG Mobile",
    "Free Fire",
    "YouTube",
    "Netflix",
    "Spotify",
  ];

  Map<String, bool> appBlockStatus = {};

  // ---------------- LOAD ----------------

  void _load() {
    themeMode = repo.getTheme();
    soundOn = repo.getSound();
    notifyOn = repo.getNotify();
    appBlockStatus = repo.getBlockedApps();

    notifyListeners();
  }

  // ---------------- THEME ----------------

  Future<void> toggleTheme(bool isDark) async {
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    await repo.saveTheme(themeMode);
    notifyListeners();
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;

  // ---------------- SOUND ----------------

  Future<void> toggleSound(bool value) async {
    soundOn = value;
    await repo.saveSound(value);
    notifyListeners();
  }

  // ---------------- NOTIFY ----------------

  Future<void> toggleNotify(bool value) async {
    notifyOn = value;
    await repo.saveNotify(value);
    notifyListeners();
  }

  // ---------------- APPS ----------------

  Future<void> toggleApp(String app, bool value) async {
    appBlockStatus[app] = value;
    await repo.saveBlockedApps(appBlockStatus);
    notifyListeners();
  }

  // ---------------- RESET (FOR LOGOUT) ----------------

  void reset() {
    themeMode = ThemeMode.system;
    soundOn = true;
    notifyOn = true;
    appBlockStatus = {};
    notifyListeners();
  }
}
