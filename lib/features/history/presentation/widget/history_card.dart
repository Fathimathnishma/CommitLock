import 'package:flutter/material.dart';

class HistoryCard extends StatelessWidget {
  final String category;
  final String dateTime;
  final int plannedDuration;
  final int actualDuration;
  final bool isCompleted;
  final int penalty;
  final VoidCallback onTap;

  const HistoryCard({
    super.key,
    required this.category,
    required this.dateTime,
    required this.plannedDuration,
    required this.actualDuration,
    required this.isCompleted,
    required this.penalty,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TOP ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  isCompleted ? "Completed" : "Broken",
                  style: TextStyle(
                    color: isCompleted ? theme.primaryColor : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            /// DATE
            Text(dateTime, style: theme.textTheme.bodyMedium),

            const SizedBox(height: 10),

            /// DURATIONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Planned: $plannedDuration min"),
                Text("Actual: $actualDuration min"),
              ],
            ),

            const SizedBox(height: 8),

            /// PENALTY
            Text(
              "Penalty: ₹$penalty",
              style: TextStyle(
                color: isCompleted ? theme.primaryColor : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
