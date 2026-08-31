# Changelog

All notable changes to the **MyNote Pro** project will be documented in this file.

## [1.0.0+4] - 2026-08-25
### Fixed
- **Database**: Fixed a critical "UNIQUE constraint failed" bug when duplicating notes.
- **UI**: Fixed visibility of unselected categories in Dark Mode (now uses high-contrast white text).
- **Editor**: Fixed mixed Bold/Italic formatting where markers would occasionally leak.
- **Checklist**: Improved checkmark visibility in Dark Mode.

## [1.0.0+3] - 2026-08-10
### Added
- **Unit Testing**: Implemented initial unit tests for `NotesCubit` and widget tests for `AppDrawer`.
- **Integration Testing**: Set up framework for end-to-end testing.
### Changed
- **Refactoring**: Massive cleanup of `NoteEditorPage`. Split into private widgets and external models.
- **Architecture**: Organized pages into feature-based subfolders (`home/`, `editor/`, `settings/`, etc.).

## [1.0.0+2] - 2026-08-01
### Added
- **WYSIWYG Formatting**: Implemented "hidden markers" for bold and italic text for a cleaner writing experience.
- **Adaptive Contrast**: Implemented logic to change icon/text colors based on note background luminance.
### Fixed
- **Dark Mode**: Overhauled `AppDrawer` and `AppBar` contrast. Fixed "invisible" text in side menus.

## [1.0.0+1] - 2026-07-30
### Added
- **Localization**: Added full Arabic language support with RTL layout and cursor fixes.
- **Settings**: Implemented Settings page with Theme and Language persistence.
- **Trash**: Added 30-day auto-purge logic for deleted notes.
- **PDF Export**: Added ability to export any note as a PDF.
- **Voice Notes**: Integrated audio recording and playback.
