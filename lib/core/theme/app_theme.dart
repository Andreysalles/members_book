import 'package:flutter/material.dart';

class AppTheme {
  // Cores baseadas na imagem
  static const Color primaryColor = Color(0xFF1A2332); // Azul escuro do fundo
  static const Color secondaryColor = Color(0xFF2A3441); // Azul médio dos cards
  static const Color accentColor = Color(0xFF4A90E2); // Azul primário
  static const Color backgroundColor = Color(0xFF0A0A0A); // Fundo muito escuro
  static const Color surfaceColor = Color(0xFF1E2A38); // Cor dos cards
  static const Color errorColor = Color(0xFFFF4444);

  // Cores específicas dos badges
  static const Color eternityColor = Color(0xFF4A90E2); // Azul do Eternity
  static const Color infinityColor = Color(0xFF4A90E2); // Azul do Infinity
  static const Color adminColor = Color(0xFFFF4444); // Vermelho do Admin

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0BEC5);
  static const Color textLight = Color(0xFF78909C);

  // Gradiente de background azul premium
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1A1A2E), // Azul escuro profundo
      Color(0xFF16213E), // Azul médio escuro
      Color(0xFF0F1419), // Azul muito escuro
      Color(0xFF0A0A0A), // Preto azulado
    ],
    stops: [0.0, 0.3, 0.7, 1.0],
  );

  // Gradiente premium para AppBar - continuação do body
  static const LinearGradient appBarGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1A1A2E), // Azul escuro profundo (início do body)
      Color(0xFF16213E), // Azul médio escuro
      Color(0xFF0F1419), // Azul muito escuro
      Color(0xFF0A0A0A), // Preto azulado (final do body)
    ],
    stops: [0.0, 0.2, 0.6, 1.0],
  );

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: textLight,
        ),
      ),
    );
  }
}
