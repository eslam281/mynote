# Implementation Plan - Dynamic Categories & Productivity Features

This plan introduces user-managed categories, a note duplication feature, and a "Recently Deleted" (Trash) system to enhance the app's utility while maintaining 100% local privacy.

## User Review Required

> [!IMPORTANT]
> - **Dynamic Categories**: Users will be able to create, edit, and delete their own categories. The previous hardcoded list will be replaced.
> - **Privacy**: All new features (Trash, Categories, Duplication) remain strictly local on the device. No data leaves the app.

## Proposed Changes

### 1. Data Layer & Database [MODIFY]
- **[SqlDb](file:///U:/StudioProjects/mynote/lib/data/database/sqldb.dart)**:
    - Add a `categories` table (`id`, `name`, `color`).
    - Add `isDeleted` (bool) and `deletedAt` (String?) columns to the `notes` table for the Trash feature.
    - Implement CRUD for categories.
- **[NoteModel](file:///U:/StudioProjects/mynote/lib/data/models/note_model.dart)**: Add `isDeleted` and `deletedAt` fields.
- **[CategoryModel] [NEW]**: Create a model for categories.

### 2. Logic [MODIFY]
- **[NotesCubit](file:///U:/StudioProjects/mynote/lib/logic/notes_cubit/notes_cubit.dart)**:
    - Add methods to fetch and manage categories.
    - Add `duplicateNote(NoteModel note)` method.
    - Update delete logic to "Soft Delete" (move to trash) vs "Permanent Delete".
    - Add `restoreNote(int id)` method.

### 3. UI/UX Enhancements [MODIFY]
- **[HomePage](file:///U:/StudioProjects/mynote/lib/presentation/pages/home_page.dart)**:
    - Update category selector to load from DB.
    - Add a "Manage Categories" option.
    - Add "Duplicate" to the note options menu.
    - Add a "Trash" view in the drawer or menu.
- **[CategoryManagerPage] [NEW]**: A screen to add/delete custom categories.
- **[NoteEditorPage](file:///U:/StudioProjects/mynote/lib/presentation/pages/note_editor_page.dart)**:
    - Fetch categories from DB for the selector.
    - Add "Note Info" (Word count, character count) in a bottom sheet.

### 4. New Suggested Features
- **Trash Can**: A safety net for deleted notes.
- **Note Duplication**: Quickly copy-paste a note's content into a new one.
- **Dynamic Colors**: Let users pick a color for their categories.

## Verification Plan

### Manual Verification
1.  **Category Management**: Create a category "Personal Stuff", use it for a note, then delete the category. Ensure the note still exists but category is cleared.
2.  **Duplication**: Duplicate a note and verify all content (title, text, color, category) is copied to a new ID.
3.  **Trash/Restore**: Delete a note, find it in the "Trash" view, and restore it. Verify it reappears in "My Notes".
4.  **Privacy Check**: Ensure no network activity is triggered by any new feature.
