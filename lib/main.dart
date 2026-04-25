import 'package:commitlock/core/services/hive_service.dart';
import 'package:commitlock/core/theme/app_theme.dart';

import 'package:commitlock/features/auth/data/data_sources/auth_local_datasource.dart';
import 'package:commitlock/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:commitlock/features/auth/presentation/provider/auth_provider.dart';

import 'package:commitlock/features/commitment/data/data_sources/commitment_local_datasources.dart';
import 'package:commitlock/features/commitment/data/model/commitment_model.dart';
import 'package:commitlock/features/commitment/data/repositories/commitment_repository_impli.dart';
import 'package:commitlock/features/commitment/presentation/provider/commitment_provider.dart';
import 'package:commitlock/features/commitment/presentation/provider/session_provider.dart';

import 'package:commitlock/features/history/presentation/provider/history_provider.dart';
import 'package:commitlock/features/home/presentation/provider/provider.dart';
import 'package:commitlock/features/settings/data/data_source/setting_localsource.dart';
import 'package:commitlock/features/settings/data/repositories/setting_repository_impli.dart';
import 'package:commitlock/features/settings/presentation/provider/setting_provider.dart';
import 'package:commitlock/features/splash/presentation/view/splash_screen.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(CommitmentModelAdapter());

  await HiveService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// Repositories
    final authRepository = AuthRepositoryImpl(
      AuthLocalDataSource(HiveService.authBox()),
    );
    final settingsRepo = SettingsRepositoryImpl(
      SettingsLocalDataSource(HiveService.settingsBox()),
    );
    final commitmentRepository = CommitmentRepositoryImpl(
      CommitmentLocalDataSource(HiveService.commitmentBox()),
    );

    return MultiProvider(
      providers: [
        /// Settings
        ChangeNotifierProvider(create: (_) => SettingsProvider(settingsRepo)),

        /// Auth
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepository)),

        /// Commitment
        ChangeNotifierProvider(
          create: (_) => NewCommitmentProvider(commitmentRepository),
        ),

        /// History (IMPORTANT FIX)
        ChangeNotifierProvider(
          create: (_) => HistoryProvider(commitmentRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeProvider(commitmentRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => SessionProvider(commitmentRepository),
        ),
      ],

      child: Consumer<SettingsProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            title: 'CommitLock',
            debugShowCheckedModeBanner: false,

            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: provider.themeMode,

            home: SplashScreens(),
          );
        },
      ),
    );
  }
}
