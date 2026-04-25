import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:commitlock/features/auth/presentation/provider/auth_provider.dart';
import 'package:commitlock/features/settings/presentation/provider/setting_provider.dart';
import 'package:commitlock/features/history/presentation/provider/history_provider.dart';
import 'package:commitlock/features/auth/presentation/view/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final auth = context.read<AuthProvider>();
    final history = context.read<HistoryProvider>();
    final settings = context.read<SettingsProvider>();

    // 🔥 RESET ALL APP STATE BEFORE LOGOUT
    await auth.logout();
    await history.clearHistory();
    settings.reset(); // <-- IMPORTANT (added below)

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Settings"), centerTitle: true),
      body: SafeArea(
        child: Consumer<SettingsProvider>(
          builder: (context, provider, child) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                /// ================= PROFILE =================
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: theme.primaryColor,
                          child: const Text(
                            "A",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Andrew",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text("+91 9876543210"),
                          ],
                        ),
                        const Spacer(),
                        Icon(Icons.edit, color: colors.onSurfaceVariant),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// ================= TOGGLES =================
                SwitchListTile(
                  activeColor: theme.primaryColor,
                  title: const Text("Dark Mode"),
                  value: provider.isDarkMode,
                  onChanged: provider.toggleTheme,
                ),

                SwitchListTile(
                  activeColor: theme.primaryColor,
                  title: const Text("Sound"),
                  value: provider.soundOn,
                  onChanged: provider.toggleSound,
                ),

                SwitchListTile(
                  activeColor: theme.primaryColor,
                  title: const Text("Notifications"),
                  value: provider.notifyOn,
                  onChanged: provider.toggleNotify,
                ),

                const SizedBox(height: 20),

                /// ================= RESTRICTION =================
                const Text(
                  "Restriction Levels",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                const Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text("Normal"),
                        subtitle: Text("Single confirmation before exit."),
                      ),
                      ListTile(
                        title: Text("Strict"),
                        subtitle: Text("Two-step confirmation with delay."),
                      ),
                      ListTile(
                        title: Text("Extreme"),
                        subtitle: Text("Must type confirmation sentence."),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// ================= APPS =================
                const Text(
                  "App Controls",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Card(
                  child: ExpansionTile(
                    title: const Text("Blocked Apps"),
                    leading: const Icon(Icons.apps),
                    children: provider.apps.map((app) {
                      return SwitchListTile(
                        title: Text(app),
                        value: provider.appBlockStatus[app] ?? false,
                        onChanged: (val) => provider.toggleApp(app, val),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 30),

                /// ================= LOGOUT =================
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Logout"),
                  onTap: () => _logout(context),
                ),

                /// ================= CLEAR HISTORY =================
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text("Clear History"),
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Clear History"),
                        content: const Text("This cannot be undone."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text("Clear"),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await context.read<HistoryProvider>().clearHistory();

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("History cleared")),
                        );
                      }
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
