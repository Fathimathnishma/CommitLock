import 'package:commitlock/core/widgets/custom_button.dart';
import 'package:commitlock/core/widgets/custom_textform.dart';
import 'package:commitlock/features/commitment/presentation/provider/commitment_provider.dart';
import 'package:commitlock/features/commitment/presentation/view/active_session.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewCommitmentScreen extends StatelessWidget {
  const NewCommitmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("New Commitment"), centerTitle: true),
      body: Consumer<NewCommitmentProvider>(
        builder: (context, state, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _sectionCard(
                context,
                title: "Habit Category",
                child: Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.categories.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 2.8,
                          ),
                      itemBuilder: (context, index) {
                        final item = state.categories[index];
                        final selected = item == state.selectedCategory;

                        return GestureDetector(
                          onTap: () => state.selectCategory(item),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: selected
                                  ? theme.primaryColor
                                  : theme.cardColor,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: selected
                                    ? theme.primaryColor
                                    : theme.dividerColor,
                              ),
                            ),
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: 12,
                                color: selected
                                    ? Colors.white
                                    : theme.textTheme.bodyMedium?.color,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    if (state.selectedCategory == "Custom") ...[
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        hintText: "Enter custom category",
                        onChanged: state.setCustomCategory,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _sectionCard(
                context,
                title: "Duration",
                child: Column(
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ...state.durations.map((d) {
                          final selected = d == state.selectedDuration;

                          return GestureDetector(
                            onTap: () => state.selectDuration(d),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? theme.primaryColor
                                    : theme.cardColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: selected
                                      ? theme.primaryColor
                                      : theme.dividerColor,
                                ),
                              ),
                              child: Text(
                                "$d min",
                                style: TextStyle(
                                  color: selected ? Colors.white : null,
                                  fontSize: 13,
                                  fontWeight: selected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }),

                        GestureDetector(
                          onTap: () => state.selectDuration(-1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: state.isCustomDuration
                                  ? theme.primaryColor
                                  : theme.cardColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: state.isCustomDuration
                                    ? theme.primaryColor
                                    : theme.dividerColor,
                              ),
                            ),
                            child: Text(
                              "Custom",
                              style: TextStyle(
                                color: state.isCustomDuration
                                    ? Colors.white
                                    : null,
                                fontSize: 13,
                                fontWeight: state.isCustomDuration
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (state.isCustomDuration) ...[
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        hintText: "Enter custom duration (minutes)",
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          final parsed = int.tryParse(val);
                          if (parsed != null) {
                            state.setCustomDuration(parsed);
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _sectionCard(
                context,
                title: "Penalty Amount (₹)",
                child: CustomTextFormField(
                  hintText: "Enter penalty amount",
                  controller: state.penaltyController,
                  keyboardType: TextInputType.number,
                ),
              ),

              const SizedBox(height: 16),

              _sectionCard(
                context,
                title: "Restriction Level",
                child: Column(
                  children: [
                    _restrictionTile(
                      context,
                      title: "Normal",
                      desc: "Simple confirmation before exit",
                      value: "Normal",
                      group: state.restriction,
                      onTap: state.setRestriction,
                    ),
                    const SizedBox(height: 10),
                    _restrictionTile(
                      context,
                      title: "Strict",
                      desc: "Double confirmation required",
                      value: "Strict",
                      group: state.restriction,
                      onTap: state.setRestriction,
                    ),
                    const SizedBox(height: 10),
                    _restrictionTile(
                      context,
                      title: "Extreme",
                      desc: "Must type confirmation text to exit",
                      value: "Extreme",
                      group: state.restriction,
                      onTap: state.setRestriction,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _sectionCard(
                context,
                title: "Blocked Categories",
                child: Column(
                  children: state.blockedApps.keys.map((key) {
                    return SwitchListTile(
                      title: Text(key),
                      value: state.blockedApps[key]!,
                      activeThumbColor: theme.primaryColor,
                      onChanged: (val) => state.toggleBlocked(key, val),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),

              CustomButton(
                text: state.isLoading ? "Starting..." : "Start Session",
                onTap: state.isLoading
                    ? null
                    : () async {
                        final error = state.validateForm();
                        if (error != null) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(error)));
                          return;
                        }

                        final sessionId = await state.createCommitment();

                        if (sessionId != null && context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ActiveSessionScreen(sessionId: sessionId),
                            ),
                          );
                        }
                      },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _restrictionTile(
    BuildContext context, {
    required String title,
    required String desc,
    required String value,
    required String group,
    required Function(String) onTap,
  }) {
    final theme = Theme.of(context);
    final selected = value == group;

    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? theme.primaryColor.withOpacity(0.15)
              : theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? theme.primaryColor : theme.dividerColor,
          ),
        ),
        child: Row(
          children: [
            Radio(
              value: value,
              groupValue: group,
              onChanged: (v) => onTap(v!),
              activeColor: theme.primaryColor,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    desc,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    final theme = Theme.of(context);

    return Card(
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}
