# Implementation Plan - Architectural Refactoring

This plan aims to improve the codebase's maintainability and readability by decomposing large page files into smaller, focused, and reusable widgets.

## User Review Required

> [!IMPORTANT]
> - **Architecture Only**: This is a pure refactoring task. **No new features** will be added, and the app's behavior will remain exactly the same.
> - **File Structure**: I will create a structured `widgets/` directory with subfolders for `home`, `editor`, and `common` components.

## Proposed Changes

### 1. Reusable Common Widgets [NEW]
- **[confirmation_dialogs.dart](file:///U:/StudioProjects/mynote/lib/presentation/widgets/common/confirmation_dialogs.dart)**:
    - `ExitConfirmationDialog`: The safety check when leaving the editor.
    - `DeleteAllConfirmationDialog`: The alert for clearing all notes.
- **[custom_bottom_sheets.dart](file:///U:/StudioProjects/mynote/lib/presentation/widgets/common/custom_bottom_sheets.dart)**:
    - `NoteOptionsSheet`: The menu for Pin, Archive, Duplicate, and Trash.
    - `NoteInfoSheet`: Displays character/word counts.

### 2. Home Screen Components [NEW]
- **[home_app_bar.dart](file:///U:/StudioProjects/mynote/lib/presentation/widgets/home/home_app_bar.dart)**: Extracts the complex `SliverAppBar` with Search and View Toggle logic.
- **[category_selector.dart](file:///U:/StudioProjects/mynote/lib/presentation/widgets/home/category_selector.dart)**: The horizontal list of dynamic category chips.
- **[notes_view.dart](file:///U:/StudioProjects/mynote/lib/presentation/widgets/home/notes_view.dart)**: Handles the logic for switching between Masonry Grid and List view.
- **[trash_reminder.dart](file:///U:/StudioProjects/mynote/lib/presentation/widgets/home/trash_reminder.dart)**: The information banner shown only in the Trash view.

### 3. Editor Screen Components [NEW]
- **[attachments_bar.dart](file:///U:/StudioProjects/mynote/lib/presentation/widgets/editor/attachments_bar.dart)**: Displays attached images/files in a clean horizontal strip.
- **[editor_bottom_panel.dart](file:///U:/StudioProjects/mynote/lib/presentation/widgets/editor/editor_bottom_panel.dart)**: Combines the attachment picker buttons and the circular color picker.

### 4. Page Cleanup [MODIFY]
- **[HomePage](file:///U:/StudioProjects/mynote/lib/presentation/pages/home_page.dart)**: Will be reduced from 450+ lines to a clean skeleton that coordinates the new widgets.
- **[NoteEditorPage](file:///U:/StudioProjects/mynote/lib/presentation/pages/note_editor_page.dart)**: Will be streamlined by removing internal build methods and moving them to the `editor/` widget folder.

## Verification Plan

### Manual Verification
1.  **Regression Testing**: Verify every single button and flow still works:
    - Create/Edit/Save note.
    - Search functionality.
    - Category filtering.
    - Grid/List toggle.
    - Biometric lock/unlock.
    - Trash purge/restore.
    - PDF Export.
2.  **UI Consistency**: Ensure the "Ocean Blue" theme and gradients remain pixel-perfect after the move.
