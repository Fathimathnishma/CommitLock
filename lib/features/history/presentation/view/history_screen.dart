import 'package:commitlock/features/history/presentation/provider/history_provider.dart';
import 'package:commitlock/features/history/presentation/widget/history_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<HistoryProvider>(context, listen: false).loadSessions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HistoryProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: provider.changeSort,
            itemBuilder: (context) => const [
              PopupMenuItem(value: "Newest", child: Text("Newest")),
              PopupMenuItem(value: "Oldest", child: Text("Oldest")),
            ],
            icon: Icon(Icons.sort, color: theme.textTheme.bodyLarge?.color),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔹 SUMMARY
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _summaryItem(context, "Sessions", provider.total.toString()),
                  _summaryItem(
                    context,
                    "Success",
                    "${provider.successRate.toStringAsFixed(0)}%",
                  ),
                  _summaryItem(context, "Time", "${provider.totalMinutes} min"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// 🔹 TAB BAR
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Row(
                children: [
                  _tab(context, "All"),
                  _tab(context, "Completed"),
                  _tab(context, "Broken"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// 🔹 LIST
            Expanded(
              child: provider.filteredList.isEmpty
                  ? Center(
                      child: Text("No Data", style: theme.textTheme.bodyMedium),
                    )
                  : ListView.builder(
                      itemCount: provider.filteredList.length,
                      itemBuilder: (context, index) {
                        final s = provider.filteredList[index];

                        return HistoryCard(
                          category: s.category,
                          dateTime: DateFormat(
                            "dd MMM, hh:mm a",
                          ).format(s.createdAt),
                          plannedDuration: s.plannedDuration,
                          actualDuration: s.actualDuration ?? 0,
                          isCompleted: s.isCompleted,
                          penalty: s.penaltyAmount,
                          onTap: () {},
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Tab UI
  Widget _tab(BuildContext context, String title) {
    final provider = Provider.of<HistoryProvider>(context);
    final theme = Theme.of(context);

    final selected = provider.selectedTab == title;

    return Expanded(
      child: GestureDetector(
        onTap: () => provider.changeTab(title),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? theme.primaryColor : theme.cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : theme.textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryItem(BuildContext context, String title, String value) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
