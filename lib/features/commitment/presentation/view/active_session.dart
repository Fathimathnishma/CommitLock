import 'package:commitlock/features/commitment/presentation/provider/session_provider.dart';
import 'package:commitlock/features/commitment/presentation/view/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class ActiveSessionScreen extends StatefulWidget {
  final String sessionId;

  const ActiveSessionScreen({super.key, required this.sessionId});

  @override
  State<ActiveSessionScreen> createState() => _ActiveSessionScreenState();
}

class _ActiveSessionScreenState extends State<ActiveSessionScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SessionProvider>().loadSession(widget.sessionId);
    });
  }

  void _handleNavigation(SessionProvider state, session) {
    if (_navigated) return;

    if (state.status == SessionStatus.completed ||
        state.status == SessionStatus.broken) {
      _navigated = true;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            isCompleted: state.status == SessionStatus.completed,
            category: session.category,
            plannedDuration: session.plannedDuration,
            actualDuration: session.actualDuration ?? 0,
            restriction: session.restrictionLevel,
            penalty: session.penaltyAmount,
            streak: 1,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Consumer<SessionProvider>(
      builder: (context, state, _) {
        final session = state.activeSession;

        if (session == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _handleNavigation(state, session);
        });

        return Scaffold(
          appBar: AppBar(title: const Text("Active Session")),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// TIMER
                    CircularPercentIndicator(
                      radius: 120,
                      lineWidth: 14,
                      percent: state.progress.clamp(0.0, 1.0),
                      center: Text(
                        state.format(state.remainingDuration),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: colors.onSurface,
                        ),
                      ),
                      progressColor: theme.primaryColor,
                      backgroundColor: colors.surfaceContainerHighest,
                      circularStrokeCap: CircularStrokeCap.round,
                    ),

                    const SizedBox(height: 30),

                    /// CATEGORY
                    Text(
                      session.category,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// PENALTY
                    Text(
                      "₹${session.penaltyAmount}",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 5),

                    /// RESTRICTION
                    Text(
                      session.restrictionLevel,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// END BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _handleExit(
                          context,
                          state,
                          session.restrictionLevel,
                        ),
                        child: const Text("End Session"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ================= EXIT LOGIC =================

  void _handleExit(BuildContext context, SessionProvider state, String level) {
    if (level == "Normal") {
      _normalExit(context, state);
    } else if (level == "Strict") {
      _strictExit(context, state);
    } else {
      _extremeExit(context, state);
    }
  }

  void _normalExit(BuildContext context, SessionProvider state) async {
    final ok = await _confirm(context, "Exit session?");
    if (ok) await state.markBroken();
  }

  void _strictExit(BuildContext context, SessionProvider state) async {
    final first = await _confirm(context, "Are you sure?");
    if (!first) return;

    await Future.delayed(const Duration(seconds: 5));

    final second = await _confirm(context, "Final confirmation?");
    if (second) await state.markBroken();
  }

  void _extremeExit(BuildContext context, SessionProvider state) async {
    final controller = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Type to Exit"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "I am breaking my commitment",
            hintStyle: TextStyle(fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(
                context,
                controller.text.trim() == "I am breaking my commitment",
              );
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await state.markBroken();
    }
  }

  Future<bool> _confirm(BuildContext context, String msg) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Confirm"),
            content: Text(msg),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Yes"),
              ),
            ],
          ),
        ) ??
        false;
  }
}
