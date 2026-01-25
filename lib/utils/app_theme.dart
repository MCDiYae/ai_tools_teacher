import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Optional: for nicer fonts

class AppColors {
  // Primary Blue (Headers, Primary Buttons)
  static const Color primaryBlue = Color(0xFF1565C0); 
  
  // Lighter Blue (List Item Backgrounds)
  static const Color lightBlue = Color(0xFFE3F2FD); 
  
  // Accent/Success (Checkmarks, Correct answers)
  static const Color successGreen = Color(0xFF43A047); 
  
  // Backgrounds
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF212121);
  static const Color textGrey = Color(0xFF757575);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: AppColors.backgroundWhite,
      
      // Define the color scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBlue,
        secondary: AppColors.lightBlue,
        surface: AppColors.backgroundWhite,
        onPrimary: Colors.white,
        onSurface: AppColors.textDark,
      ),

      // AppBar Theme (Uniform across screens)
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white, // Color of icons and title
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      // Button Theme (For 'Create Exams', 'Next', 'Generate')
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners like UI
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        // Splash Screen Title
        headlineLarge: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryBlue,
        ),
        // Screen Headers (e.g. "Select Subject")
        headlineMedium: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
        // List Item Titles (e.g. "Mathematics")
        titleMedium: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryBlue,
        ),
        // Body Text (e.g. Exercise content)
        bodyMedium: GoogleFonts.roboto(
          fontSize: 16,
          color: AppColors.textDark,
          height: 1.5, // Better readability for questions
        ),
        // Small labels or hints
        bodySmall: GoogleFonts.roboto(
          fontSize: 14,
          color: AppColors.textGrey,
        ),
      ),
      
      // Card Theme (Used for the Subject/Grade list items)
      cardTheme: CardThemeData(
        color: AppColors.lightBlue,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}