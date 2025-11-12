// lib/main.dart
import 'package:flutter/material.dart';
import 'package:smart_extinguisher_app/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 디자인 시스템 색상
    const primary = Color(0xFF0A84FF); // 모던 블루
    const primaryContainer = Color(0xFFD9EEFF);
    const surface = Colors.white;
    const background = Color(0xFFF6F7FB); // 연한 회색 배경
    const accent = Color(0xFF34C759); // 필요 시 사용

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: accent,
        background: background,
        surface: surface,
      ),
    );

    return MaterialApp(
      title: '소화기 관리 앱',
      theme: base.copyWith(
        scaffoldBackgroundColor: background,

        // AppBar
        appBarTheme: base.appBarTheme.copyWith(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
        ),

        // Card (토스 스타일 카드)
        cardTheme: base.cardTheme.copyWith(
          color: surface,
          elevation: 6,
          shadowColor: Colors.black.withOpacity(0.06),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        // Elevated button (하단 고정 버튼 등)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            elevation: 2,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),

        // Filled button for alternative actions (if needed)
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: primaryContainer,
            foregroundColor: primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),

        // Text button (회원가입 링크 등)
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primary,
            textStyle: const TextStyle(fontSize: 15),
          ),
        ),

        // Input decoration (일관된 입력창)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: primary, width: 1.5),
          ),
          hintStyle: TextStyle(color: Colors.grey[600]),
        ),

        // Text theme tweaks
        textTheme: base.textTheme.apply(
          bodyColor: Colors.grey[900],
          displayColor: Colors.grey[900],
        ).copyWith(
          titleMedium: base.textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
        ),

        // Dialog / Bottom sheet shape consistency
        dialogTheme: base.dialogTheme.copyWith(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
