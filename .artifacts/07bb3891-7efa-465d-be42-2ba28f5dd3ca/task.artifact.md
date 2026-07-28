# Tasks - Exit Confirmation & Trash Auto-Purge

- `[x]` Database Logic
    - `[x]` Add `purgeDeletedNotes` to `SqlDb`
- `[x]` Business Logic
    - `[x]` Call `purgeDeletedNotes` in `NotesCubit.loadNotes`
- `[x]` Note Editor Improvements
    - `[x]` Add "dirty check" logic to `NoteEditorPage`
    - `[x]` Implement `PopScope` with `AlertDialog` for unsaved changes
- `[x]` Home Page UI
    - `[x]` Add Trash cleanup reminder banner
- `[x]` Verification
    - `[x]` Test back button with changes
    - `[x]` Verify 30-day purge logic
