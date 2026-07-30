import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../logic/l10n/app_localizations.dart';
import '../../logic/settings_cubit/settings_cubit.dart';
import '../../logic/settings_cubit/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('settings')),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSectionTitle(context, l10n.translate('appearance')),
              Card(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.brightness_6_outlined),
                      title: Text(l10n.translate('theme_mode')),
                      trailing: DropdownButton<ThemeMode>(
                        value: state.themeMode,
                        underline: const SizedBox(),
                        dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                        onChanged: (mode) {
                          if (mode != null) {
                            context.read<SettingsCubit>().updateTheme(mode);
                          }
                        },
                        items: [
                          DropdownMenuItem(value: ThemeMode.system, child: Text(l10n.translate('system'))),
                          DropdownMenuItem(value: ThemeMode.light, child: Text(l10n.translate('light'))),
                          DropdownMenuItem(value: ThemeMode.dark, child: Text(l10n.translate('dark'))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle(context, l10n.translate('localization')),
              Card(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.language_rounded),
                      title: Text(l10n.translate('app_language')),
                      trailing: DropdownButton<String>(
                        value: state.locale.languageCode,
                        underline: const SizedBox(),
                        dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                        onChanged: (lang) {
                          if (lang != null) {
                            context.read<SettingsCubit>().updateLanguage(lang);
                          }
                        },
                        items: [
                          DropdownMenuItem(value: 'en', child: Text(l10n.translate('english'))),
                          DropdownMenuItem(value: 'ar', child: Text(l10n.translate('arabic'))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle(context, l10n.translate('about')),
              Card(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info_outline_rounded),
                      title: Text(l10n.translate('app_title')),
                      subtitle: Text('${l10n.translate('version')} 1.2.0'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.security_rounded),
                      title: Text(l10n.translate('privacy_first')),
                      subtitle: Text(l10n.translate('privacy_desc')),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8, right: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
