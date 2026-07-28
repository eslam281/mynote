# Implementation Plan - Exit Confirmation & Trash Auto-Purge

This plan introduces a safety confirmation dialog when leaving the note editor with unsaved changes and implements an automatic 30-day cleanup for the Trash.

## User Review Required

> [!IMPORTANT]
> - **Exit Safety**: You will no longer lose your work by accidentally clicking the back arrow. A dialog will ask if you want to Save or Discard.
> - **Auto-Cleanup**: Notes moved to Trash will be **permanently deleted after 30 days**. A reminder will be shown at the top of the Trash screen.

## Proposed Changes

### 1. Trash Auto-Purge Logic [MODIFY]
- **[SqlDb](file:///U:/StudioProjects/mynote/lib/data/database/sqldb.dart)**:
    - Add `Future<int> purgeDeletedNotes(int days)` method to delete records where `isDeleted = 1` and `deletedAt` is older than the threshold.
- **[NotesCubit](file:///U:/StudioProjects/mynote/lib/logic/notes_cubit/notes_cubit.dart)**:
    - Update `loadNotes` to call the purge method every time the notes are loaded (ensuring the trash stays clean).

### 2. Exit Confirmation Dialog [MODIFY]
- **[NoteEditorPage](file:///U:/StudioProjects/mynote/lib/presentation/pages/note_editor_page.dart)**:
    - Wrap the `Scaffold` in a `PopScope`.
    - Implement a "dirty check" to see if the current text/attachments differ from the original note.
    - Show a modern Material 3 `AlertDialog` when the user tries to go back without saving.

### 3. Trash Reminder UI [MODIFY]
- **[HomePage](file:///U:/StudioProjects/mynote/lib/presentation/pages/home_page.dart)**:
    - Add a warning banner at the top of the `CustomScrollView` when viewing the Trash (`isShowingTrash == true`).
    - The banner will state: "Notes in Trash will be permanently deleted after 30 days."

## Verification Plan

### Manual Verification
1.  **Exit Dialog**:
    - Open "New Note", type something, then click the back arrow. Verify the dialog appears.
    - Click "Save" and verify the note is saved.
    - Click "Discard" and verify the note is NOT saved.
2.  **Trash Purge**:
    - Manually set a note's `deletedAt` to 31 days ago in the database (for testing).
    - Open the app and verify the note is gone from the Trash.
3.  **UI Banner**:
    - Go to Trash. Verify the blue/info banner is visible at the top.
