import 'package:commitlock/features/history/presentation/view/history_screen.dart';
import 'package:commitlock/features/home/presentation/view/home_screen.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final bool isCompleted;
  final String category;
  final int plannedDuration;
  final int actualDuration;
  final String restriction;
  final int penalty;
  final int streak;

  const ResultScreen({
    super.key,
    required this.isCompleted,
    required this.category,
    required this.plannedDuration,
    required this.actualDuration,
    required this.restriction,
    required this.penalty,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async => false, // 🚫 prevent going back
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Session Result"),
          centerTitle: true,
          automaticallyImplyLeading: false, // 🚫 remove back button
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// 🔹 STATUS ICON
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted
                      ? theme.primaryColor.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                ),
                child: Icon(
                  isCompleted ? Icons.check : Icons.close,
                  size: 50,
                  color: isCompleted ? theme.primaryColor : Colors.red,
                ),
              ),

              const SizedBox(height: 20),

              /// 🔹 STATUS TEXT
              Text(
                isCompleted ? "Completed 🎉" : "Broken 💔",
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isCompleted ? theme.primaryColor : Colors.red,
                ),
              ),

              const SizedBox(height: 20),

              /// 🔹 DETAILS CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _row("Habit", category),
                    _row("Planned Duration", "$plannedDuration min"),
                    _row("Actual Duration", "$actualDuration min"),
                    _row("Restriction", restriction),

                    /// 🔴 Show penalty only if broken
                    if (!isCompleted) _row("Penalty Paid", "₹$penalty"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// 🔹 STREAK (only if completed)
              if (isCompleted)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Streak: $streak days",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

              const Spacer(),

              /// 🔹 BUTTONS
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        "Dashboard",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HistoryScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text("History"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Reusable Row
  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
