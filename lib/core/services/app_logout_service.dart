import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/provider/auth_provider.dart';
import '../../features/commitment/presentation/provider/session_provider.dart';
import '../../features/history/presentation/provider/history_provider.dart';
import '../../features/settings/presentation/provider/setting_provider.dart';
import '../../features/auth/presentation/view/login_screen.dart';
import '../../core/services/hive_service.dart';

class AppLogoutService {
  static Future<void> logout(BuildContext context) async {
    // 1. Clear Hive (IMPORTANT)
    await HiveService.authBox().clear();
    await HiveService.commitmentBox().clear();

    // 2. Reset Providers
    context.read<AuthProvider>().logout();
    context.read<SessionProvider>().reset();
    context.read<HistoryProvider>().clearHistory();
    context.read<SettingsProvider>().reset();

    // 3. Navigate clean
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }
}
