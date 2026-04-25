import 'package:commitlock/features/commitment/presentation/view/active_session.dart';
import 'package:commitlock/features/commitment/presentation/view/new_Commitment.dart';
import 'package:commitlock/features/history/presentation/view/history_screen.dart';
import 'package:commitlock/features/home/presentation/provider/provider.dart';
import 'package:commitlock/features/settings/presentation/view/setting_sreen.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final home = context.watch<HomeProvider>();

    final percent = home.progress.clamp(0.0, 1.0);

    return Scaffold(
      drawer: _buildDrawer(context),

      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.primaryColor,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewCommitmentScreen()),
          );

          context.read<HomeProvider>().load();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Builder(
                        builder: (context) => GestureDetector(
                          onTap: () => Scaffold.of(context).openDrawer(),
                          child: CircleAvatar(
                            backgroundColor: theme.primaryColor,
                            child: const Text(
                              "J",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Hi James 👋",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  IconButton(
                    icon: const Icon(Icons.history),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HistoryScreen(),
                        ),
                      );
                      context.read<HomeProvider>().load();
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// PROGRESS + STREAK
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircularPercentIndicator(
                    radius: 70,
                    lineWidth: 10,
                    percent: percent,
                    progressColor: theme.primaryColor,
                    backgroundColor: theme.dividerColor,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${(percent * 100).toStringAsFixed(0)}%"),
                        const Text("Today"),
                      ],
                    ),
                  ),

                  Column(
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.orange,
                        size: 40,
                      ),
                      Text("${home.streak} Days"),
                      const Text("Streak"),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// ACTIVE SESSION
              if (home.activeSession != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(home.activeSession!.category),
                      const SizedBox(height: 10),
                      Text("${home.activeSession!.plannedDuration} min"),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ActiveSessionScreen(
                                sessionId: home.activeSession!.id,
                              ),
                            ),
                          );
                          context.read<HomeProvider>().load();
                        },
                        child: const Text("Resume"),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              const Text("Today Tasks"),
              const SizedBox(height: 10),

              Expanded(
                child: home.todaySessions.isEmpty
                    ? const Center(child: Text("No sessions today"))
                    : ListView.builder(
                        itemCount: home.todaySessions.length,
                        itemBuilder: (_, i) {
                          final s = home.todaySessions[i];
                          return _tile(
                            context,
                            s.category,
                            "${s.plannedDuration} min",
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, String title, String time) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title), Text(time)],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final theme = Theme.of(context);

    const String userName = "James";
    const String userEmail = "james@gmail.com";

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: theme.primaryColor),
            accountName: Text(
              userName,
              style: TextStyle(
                color: theme.hintColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              userEmail,
              style: TextStyle(color: theme.hintColor.withOpacity(0.9)),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: theme.scaffoldBackgroundColor,
              child: Text(
                userName[0],
                style: TextStyle(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          ListTile(
            leading: Icon(Icons.settings, color: theme.hintColor),
            title: Text("Settings", style: TextStyle(color: theme.hintColor)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
