# Gemini.md - MyNote Pro Project Memory

## Project Overview
MyNote Pro is a high-performance, privacy-first Flutter note-taking app. It features a WYSIWYG markdown editor, audio recording, biometric security, category filtering, and local SQLite persistence. Data never leaves the device.

## Architecture & Layers
For new features and refactoring, follow the **Clean Architecture** protocol defined in [SKILLS.md](file:///U:/StudioProjects/mynote/SKILLS.md).

### 1. Data Layer (`lib/data`)
- **SQLite (`data/database/sqldb.dart`)**: Version 6. Handles `notes` and `categories` tables.
    - **Note Schema**: `id`, `title`, `content`, `color`, `isPinned`, `isArchived`, `isDeleted`, `deletedAt`, `category`, `attachments` (JSON string), `isLocked`, `isChecklist`, `reminderAt`, `createdAt`.
    - **Category Schema**: `id`, `name`, `color`.
    - **Auto-Purge**: Logic in `NotesCubit` calls `sqlDb.purgeDeletedNotes(30)` to clear trash older than 30 days.
- **Models (`data/models/`)**: `NoteModel`, `CategoryModel`, `ChecklistItem`. All use `Equatable` and `toMap/fromMap`.

### 2. Logic Layer (`lib/logic`)
- **State Management**: `flutter_bloc` (Cubit).
    - `NotesCubit` (`logic/notes_cubit/`): Manages CRUD, archive, trash, category filter, pinning, search, and view mode (Grid/List).
    - `SettingsCubit` (`logic/settings_cubit/`): Manages `ThemeMode` and `Locale` with `shared_preferences` persistence.
- **Services (`logic/services/`)**:
    - `AudioService`: Handles `record` and `audioplayers` for voice notes.
    - `PdfService`: Generates professional PDF exports of notes (`pdf`, `printing`).
    - `AuthService`: Local biometric authentication (`local_auth`).
    - `FileService`: Manages local attachment storage in app documents (`path_provider`).
    - `MarkdownTextController`: Custom WYSIWYG logic hiding markers (`***`, `**`, `*`) using `fontSize: 0.01` and `Colors.transparent`.
- **Localization (`logic/l10n/`)**: `AppLocalizations` supporting English ('en') and Arabic ('ar').

### 3. Presentation Layer (`lib/presentation`)
- **Feature-Based Pages (`presentation/pages/`)**: Organized into subfolders: `splash/`, `home/`, `editor/`, `settings/`, `category/`, `info/`.
- **Modular Widgets (`presentation/widgets/`)**: Subdivided into `common/`, `editor/`, `home/`, alongside `app_drawer.dart` and `note_card.dart`.
- **Adaptive UI**: High-contrast logic using `ThemeData.estimateBrightnessForColor`. Toolbar icons and text colors dynamically flip between Dark Blue and White based on note background.
- **Localization**: Over 50 keys in English/Arabic. Supports full RTL with proper layout and cursor alignment.

## Critical Patterns & Rules
1. **No ID Reuse**: When duplicating notes, always create a fresh `NoteModel` instance without an ID to let SQLite auto-increment.
2. **Note Contrast**: Unselected Category chips must be legible in Dark Mode (use `white.withValues(alpha: 0.1)` backgrounds).
3. **Checklist Logic**: Stored as a JSON string in the `content` column when `isChecklist` is true.
4. **Formatting Toggle**: `_formatText` in `NoteEditorPage` handles wrapping/unwrapping and "inside-marker" detection.
5. **WYSIWYG Accuracy**: Longest regex patterns (e.g., `***` for Bold+Italic) must be matched first in `MarkdownTextController`.
6. **System Photo Picker & Permissions**: Do not request broad media storage permissions (`READ_MEDIA_IMAGES`, `READ_MEDIA_VIDEO`). All image picks are handled natively by System Photo Picker via `image_picker`. Transitive media permissions are explicitly stripped in `AndroidManifest.xml` with `tools:node="remove"`.

## Commands
- **Sync**: `flutter pub get`
- **Run**: `flutter run`
- **Check**: `flutter analyze`
- **Test**:
  - Unit: `flutter test test/unit/notes_cubit_test.dart`
  - Widget: `flutter test test/widget/app_drawer_test.dart` and `flutter test test/widget/splash_page_test.dart`
  - Integration: `flutter test integration_test/app_test.dart`
  - All: `flutter test`

## UI Conventions
- Use `SliverAppBar.large` or custom slivers for main screens (`HomePage`, `AboutUsPage`).
- Split massive build methods into private widgets or modular components under `lib/presentation/widgets/`.
- Attachments use `Hero` animations and open via `AttachmentViewerPage` (images) or `open_filex` / `url_launcher`.
