# CLAUDE.md - MyNote Pro Project Memory

## Project Overview
MyNote Pro is a high-performance, privacy-first Flutter note-taking app. It features a WYSIWYG markdown editor, audio recording, biometric security, and local SQLite persistence. Data never leaves the device.

## Architecture & Layers
### 1. Data Layer (`lib/data`)
- **SQLite (`database/sqldb.dart`)**: Version 6. Handles `notes` and `categories` tables.
    - **Note Schema**: `id`, `title`, `content`, `color`, `isPinned`, `isArchived`, `isDeleted`, `deletedAt`, `category`, `attachments` (JSON string), `isLocked`, `isChecklist`, `reminderAt`, `createdAt`.
    - **Auto-Purge**: Logic in `NotesCubit` calls `sqlDb.purgeDeletedNotes(30)` to clear trash older than 30 days.
- **Models (`models/`)**: `NoteModel`, `CategoryModel`, `ChecklistItem`. All use `Equatable` and `toMap/fromMap`.

### 2. Logic Layer (`lib/logic`)
- **State Management**: `flutter_bloc` (Cubit).
    - `NotesCubit`: Manages CRUD, archive, trash, search, and view mode (Grid/List).
    - `SettingsCubit`: Manages `ThemeMode` and `Locale` with `shared_preferences` persistence.
- **Services (`services/`)**:
    - `AudioService`: Handles `record` and `audioplayers` for voice notes.
    - `PdfService`: Generates professional PDF exports of notes.
    - `AuthService`: Local biometric authentication (Local Auth).
    - `FileService`: Manages local attachment storage in app documents.
    - `MarkdownTextController`: Custom WYSIWYG logic hiding markers (`**`, `*`) using `fontSize: 0.01` and `Colors.transparent`.

### 3. Presentation Layer (`lib/presentation`)
- **Feature-Based Pages**: Organized into subfolders: `home/`, `editor/`, `settings/`, `category/`, `info/`.
- **Adaptive UI**: High-contrast logic using `ThemeData.estimateBrightnessForColor`. Toolbar icons and text colors dynamically flip between Dark Blue and White based on note background.
- **Localization (`l10n/`)**: Over 50 keys in English/Arabic. Supports full RTL with cursor fixes.

## Critical Patterns & Rules
1. **No ID Reuse**: When duplicating notes, always create a fresh `NoteModel` instance without an ID to let SQLite auto-increment.
2. **Note Contrast**: Unselected Category chips must be legible in Dark Mode (use `white.withValues(alpha: 0.1)` backgrounds).
3. **Checklist Logic**: Stored as a JSON string in the `content` column when `isChecklist` is true.
4. **Formatting Toggle**: `_formatText` in `NoteEditorPage` handles wrapping/unwrapping and "inside-marker" detection.
5. **WYSIWYG Accuracy**: Longest regex patterns (e.g., `***` for Bold+Italic) must be matched first in `MarkdownTextController`.

## Commands
- **Sync**: `flutter pub get`
- **Run**: `flutter run`
- **Check**: `flutter analyze`
- **Test**: `flutter test` (Unit: `test/unit/notes_cubit_test.dart`, Widget: `test/widget/app_drawer_test.dart`)

## UI Conventions
- Use `SliverAppBar.large` for main screens (`HomePage`, `AboutUsPage`).
- Split massive build methods into private widgets (e.g., `_buildTitleField()`).
- Attachments use `Hero` animations and open via `AttachmentViewerPage` (images) or `open_file_plus`.
