import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    final themeIndex = prefs.getInt('theme_mode') ?? ThemeMode.system.index;
    final langCode = prefs.getString('language_code') ?? 'en';

    emit(state.copyWith(
      themeMode: ThemeMode.values[themeIndex],
      locale: Locale(langCode),
    ));
  }

  Future<void> updateTheme(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', themeMode.index);
    emit(state.copyWith(themeMode: themeMode));
  }

  Future<void> updateLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', langCode);
    emit(state.copyWith(locale: Locale(langCode)));
  }
}
