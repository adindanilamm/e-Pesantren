import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/admin/admin_dashboard.dart';
import 'presentation/screens/ustadz/ustadz_dashboard.dart';
import 'presentation/screens/wali/wali_dashboard.dart';
import 'core/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: authState.when(
        data: (user) {
          if (user == null) {
            return const LoginScreen();
          }

          // Role-based routing
          switch (user.role) {
            case AppConstants.roleAdmin:
              return const AdminDashboard();
            case AppConstants.roleUstadz:
              return const UstadzDashboard();
            case AppConstants.roleWali:
              return const WaliDashboard();
            default:
              return const LoginScreen();
          }
        },
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: AppTheme.primaryTeal),
          ),
        ),
        error: (error, stack) =>
            Scaffold(body: Center(child: Text('Error: $error'))),
      ),
    );
  }
}
