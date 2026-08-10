# Implementation Plan - Project Cleanup & Modularization

This plan addresses the technical debt by restructuring the project architecture and refining the UI logic for better readability and performance.

## User Review Required

> [!IMPORTANT]
> - **Folder Architecture**: All pages are now organized into subfolders (e.g., `home/`, `editor/`, `settings/`). This might require you to re-orient yourself in the file tree, but it makes finding specific logic much easier.
> - **NoteEditor Modularization**: The Note Editor code has been split into smaller logical pieces. Instead of one 500-line file, it's now a clean, structured component.
> - **High-Contrast Chips**: I've overhauled the category chip colors to ensure perfect legibility in both Light and Dark modes.

## Proposed Changes

### 1. Project Reorganization [MOVE]
- **Structure**: Group pages by feature area under `lib/presentation/pages/`.
- **Imports**: Bulk update all project imports to use the new directory structure.

### 2. NoteEditor Refactoring [MODIFY]
- **File**: `lib/presentation/pages/editor/note_editor_page.dart`.
- **Logic**: Extract `ChecklistItem` to a separate model.
- **UI**: Move repetitive UI building blocks into private widgets.
- **Bug Fix**: Apply dynamic text colors to chips using `ThemeData.estimateBrightnessForColor`.

### 3. Localization Consistency [MODIFY]
- **Audit**: Ensure all newly organized pages still correctly pull from `AppLocalizations`.

## Verification Plan

### Manual Verification
1.  **Navigation**: Click through every link in the AppDrawer to ensure routing still works with the new folder structure.
2.  **Editor Stability**: Create a note, add a checklist, and change colors to verify no logic was lost during refactoring.
3.  **Contrast Test**: Check category chips on a White background in Light Mode to ensure text is sharp and dark.
