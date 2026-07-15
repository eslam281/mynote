# Implementation Plan - MyNote Modernization

This plan aims to transform the current "My Notes" app into a highly polished, feature-rich, and performant note-taking application, moving away from the "glass design" to a modern, vibrant Material 3 aesthetic.

## User Review Required

> [!IMPORTANT]
> - The "Glass Design" will be replaced by a modern "Bento Box" / "Card-based" design using Material 3 principles.
> - All data remains 100% local (Sqflite). No user accounts, passwords, or cloud sync will be added, as per your privacy request.

## Proposed Changes

### 1. Core & Dependencies
- Add `flutter_animate` for smooth UI transitions.
- Add `share_plus` for note sharing.
- Add `lottie` for engaging empty-state animations.
- Refine `NotesCubit` states to minimize UI flickering.

### 2. Database & Models [MODIFY]
- **[NoteModel](file:///U:/StudioProjects/mynote/lib/data/models/note_model.dart)**: Add `isArchived` (bool) and `category` (String?) fields.
- **[SqlDb](file:///U:/StudioProjects/mynote/lib/data/database/sqldb.dart)**: Update schema to include new columns and add migration logic.

### 3. Logic [MODIFY]
- **[NotesCubit](file:///U:/StudioProjects/mynote/lib/logic/notes_cubit/notes_cubit.dart)**:
    - Add methods for archiving/unarchiving.
    - Add category filtering logic.
    - Improve state management to support "Silent Updates" (reloading without showing a full-screen spinner).

### 4. UI/UX Overhaul [MODIFY]
- **[main.dart](file:///U:/StudioProjects/mynote/lib/main.dart)**: Enhance `ThemeData` with better color schemes and typography.
- **[HomePage](file:///U:/StudioProjects/mynote/lib/presentation/pages/home_page.dart)**:
    - Replace `AppBar` with `SliverAppBar` for a dynamic "Large Title" effect.
    - Add a Category selector (chips) at the top.
    - Implement a Toggle for Grid/List view.
    - Add Swipe-to-Archive/Delete (if in list view) or better long-press menus.
- **[NoteCard](file:///U:/StudioProjects/mynote/lib/presentation/widgets/note_card.dart)**:
    - Completely redesign into a modern "Bento" style card.
    - Remove semi-transparent "glass" borders and low-opacity backgrounds in favor of solid, vibrant colors with subtle shadows and clean typography.
- **[NoteEditorPage](file:///U:/StudioProjects/mynote/lib/presentation/pages/note_editor_page.dart)**:
    - Improve color picker.
    - Add "Share" functionality.
    - Add "Category" selection.

### 5. New Features
- **Archive System**: Move notes to an "Archive" view to keep the home screen clean.
- **Category Tags**: Organize notes by tags (Work, Personal, Ideas, etc.).
- **Search Highlighting**: Visually highlight the search query in note titles/content.

## Verification Plan

### Automated Tests
- Run `flutter test` to ensure existing logic holds.
- Add unit tests for the new `isArchived` and `category` logic in `NotesCubit`.

### Manual Verification
1.  **UI Check**: Verify the new design looks "attractive" and "modern" on both light and dark modes.
2.  **Performance Check**: Ensure smooth scrolling with a large number of notes and no "flash" during search.
3.  **Feature Check**:
    - Create, Edit, Pin, Archive, and Delete notes.
    - Filter by category.
    - Toggle Grid/List view.
    - Share a note to another app.
