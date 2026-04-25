import 'package:commitlock/features/auth/presentation/provider/auth_provider.dart';
import 'package:commitlock/features/auth/presentation/view/login_screen.dart';
import 'package:commitlock/features/commitment/presentation/provider/session_provider.dart';
import 'package:commitlock/features/home/presentation/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreens extends StatefulWidget {
  const SplashScreens({super.key});

  @override
  State<SplashScreens> createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    _startAnimation();
    _startNavigation();
  }

  // ---------------- ANIMATION ----------------
  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;

    setState(() => _opacity = 1.0);
  }

  // ---------------- NAVIGATION ----------------
  void _startNavigation() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    await _init();
  }

  Future<void> _init() async {
    final auth = context.read<AuthProvider>();
    final session = context.read<SessionProvider>();

    final isLoggedIn = auth.repository.checkLogin();

    if (!mounted) return;

    if (isLoggedIn) {
      await session.loadActiveSession();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(seconds: 2),
          opacity: _opacity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "CommitLock",
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Build discipline. Stay accountable.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
