import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'data/database/sqldb.dart';
import 'logic/l10n/app_localizations.dart';
import 'logic/notes_cubit/notes_cubit.dart';
import 'logic/settings_cubit/settings_cubit.dart';
import 'logic/settings_cubit/settings_state.dart';
import 'presentation/pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NotesCubit(SqlDb())),
        BlocProvider(create: (context) => SettingsCubit()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'My Notes',
            debugShowCheckedModeBanner: false,
            locale: state.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English
              Locale('ar', ''), // Arabic
            ],
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF0061A4),
                brightness: Brightness.light,
                surface: const Color(0xFFF0F4F8),
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
                iconTheme: const IconThemeData(color: Color(0xFF001E30)),
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
                surface: const Color(0xFF121212),
              ),
              textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).primaryTextTheme),
              appBarTheme: AppBarTheme(
                centerTitle: false,
                elevation: 0,
                backgroundColor: const Color(0xFF121212),
                titleTextStyle: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              cardTheme: CardThemeData(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                color: const Color(0xFF1E1E1E),
              ),
              dropdownMenuTheme: DropdownMenuThemeData(
                textStyle: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
            themeMode: state.themeMode,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
