# Implementation Plan - Full Localization & Dark Mode Fix

This plan fixes the invisible AppBar in Dark Mode and implements actual text translations for the entire app.

## User Review Required

> [!IMPORTANT]
> - **Full Translation**: I will implement a system that translates **all** buttons, titles, and labels when you switch to Arabic.
> - **Dark Mode Polish**: I will explicitly set Dark Mode colors for the AppBar to ensure it is always visible and consistent.

## Proposed Changes

### 1. Localization System [NEW]
- **[AppLocalizations](file:///U:/StudioProjects/mynote/lib/logic/l10n/app_localizations.dart)**:
    - Create a custom delegate and a class that stores all app strings in both Arabic and English.
    - Example keys: `homeTitle`, `settings`, `delete`, `save`, `trash`, etc.

### 2. Theme Correction [MODIFY]
- **[main.dart](file:///U:/StudioProjects/mynote/lib/main.dart)**:
    - Update `darkTheme` to include a full `AppBarTheme` with a dark surface color and white text.
    - Standardize `SliverAppBar` background colors to adapt correctly to Dark Mode.

### 3. UI Translation [MODIFY]
- **All Pages**: Update every screen to use `AppLocalizations.of(context).translate('key')` instead of hardcoded Arabic or English text.
    - Screens involved: Home, Editor, Settings, Drawer, Category Manager, About, Contact.

## Verification Plan

### Manual Verification
1.  **Dark Mode Visibility**: Turn on Dark Mode and go to Settings. Verify the AppBar is clearly visible with a dark background and readable title.
2.  **Language Check (Arabic)**: Switch language to Arabic. Verify that "Settings" changes to "الإعدادات", "Trash" changes to "سلة المهملات", etc.
3.  **Language Check (English)**: Switch back to English and verify all strings revert correctly.
4.  **Consistency**: Ensure the "All" category bug and RTL alignment fixes remain intact.
