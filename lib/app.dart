import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/puv_management_screen.dart';
import 'screens/passenger_counting_screen.dart';
import 'screens/counting_history_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/settings_screen.dart';

class PuvPassengerCountingApp extends StatelessWidget {
  const PuvPassengerCountingApp({super.key});

  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color darkNavy = Color(0xFF0B1220);
  static const Color panelNavy = Color(0xFF111C2E);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PUV Vision',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: darkNavy,
        colorScheme: const ColorScheme.dark(
          primary: primaryBlue,
          secondary: Color(0xFF60A5FA),
          surface: panelNavy,
          error: Color(0xFFEF4444),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: darkNavy,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: panelNavy,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(
              color: Color(0xFF263449),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF172338),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          hintStyle: const TextStyle(
            color: Color(0xFF8492A8),
          ),
          labelStyle: const TextStyle(
            color: Color(0xFFB7C3D4),
          ),
          prefixIconColor: const Color(0xFF94A3B8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF334155),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF334155),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: primaryBlue,
              width: 2,
            ),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF60A5FA),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFF263449),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/puvs': (context) => const PuvManagementScreen(),
        '/counting': (context) => const PassengerCountingScreen(),
        '/history': (context) => const CountingHistoryScreen(),
        '/reports': (context) => const ReportsScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}