import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_colors.dart'; // <-- import the colors class

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.onboarding,
      onGenerateRoute: AppRoutes.generateRoute,

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
          brightness: Brightness.light,
          background: AppColors.backgroundColor,
        ),

        scaffoldBackgroundColor: AppColors.backgroundColor,

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: AppColors.primaryColor, // use AppColors
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 14,
            ),
          ),
        ),

        textTheme: GoogleFonts.urbanistTextTheme(
          TextTheme(
            displayLarge: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
            titleLarge: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
            bodyLarge: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              color: AppColors.subtitleColor,
            ),
          ),
        ),
      ),
    );
  }
}
