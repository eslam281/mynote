import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'data/database/sqldb.dart';
import 'logic/notes_cubit/notes_cubit.dart';
import 'presentation/pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesCubit(SqlDb()),
      child: MaterialApp(
        title: 'My Notes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0061A4), // Deep Ocean Blue
            brightness: Brightness.light,
            surface: const Color(0xFFF0F4F8), // Very light blue-gray
          ),
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          appBarTheme: AppBarTheme(
            centerTitle: false,
            elevation: 0,
            backgroundColor: const Color(0xFFF0F4F8),
            titleTextStyle: GoogleFonts.poppins(
              color: const Color(0xFF001E30),
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          chipTheme: ChipThemeData(
            backgroundColor: Colors.white,
            selectedColor: const Color(0xFF0061A4).withValues(alpha: 0.1),
            labelStyle: const TextStyle(color: Colors.black87),
            secondaryLabelStyle: const TextStyle(color: Colors.white),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shadowColor: Colors.black.withValues(alpha: 0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            color: Colors.white,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: const Color(0xFF0061A4),
            foregroundColor: Colors.white,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1875DE),
            brightness: Brightness.dark,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).primaryTextTheme),
        ),
        themeMode: ThemeMode.system,
        home: const HomePage(),
      ),
    );
  }
}
