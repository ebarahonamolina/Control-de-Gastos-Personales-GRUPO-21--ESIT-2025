import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Paleta de colores de la app
    const darkPrimary = Color(0xFF081c15);
    const midPrimary = Color(0xFF1b4332);
    const darkSecondary = Color(0xFF2d6a4f);
    const midSecondary = Color(0xFF40916c);
    const accent = Color(0xFF52b788);

    return MaterialApp(
      title: 'Control de Gastos',
      theme: ThemeData(
        scaffoldBackgroundColor: accent, // Color del fondo de la app
        primaryColor: darkPrimary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: midPrimary,
          primary: darkPrimary,
          secondary: accent,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.alatsiTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: darkPrimary,
          foregroundColor: Colors.white,
          titleTextStyle: GoogleFonts.alatsi(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: darkSecondary,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: midPrimary,
            foregroundColor: Colors.white,
            textStyle: GoogleFonts.alatsi(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: midSecondary,
            textStyle: GoogleFonts.alatsi(),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
