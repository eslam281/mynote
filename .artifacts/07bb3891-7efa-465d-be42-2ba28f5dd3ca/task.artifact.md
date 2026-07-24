# Tasks - Dynamic Features & Productivity

- `[x]` Database & Models
    - `[x]` Update `NoteModel` (add `isDeleted`, `deletedAt`)
    - `[x]` Create `CategoryModel`
    - `[x]` Update `SqlDb` (schema v3: `categories` table, `notes` updates)
- `[x]` Logic Layer
    - `[x]` Update `NotesState` for dynamic categories and trash view
    - `[x]` Update `NotesCubit` (CRUD for categories, Soft Delete, Duplicate)
- `[x]` UI Overhaul
    - `[x]` Create `CategoryManagerPage`
    - `[x]` Update `HomePage` (Dynamic Chip loading, Duplication, Trash view)
    - `[x]` Update `NoteEditorPage` (Fetch categories from DB)
- `[x]` Verification
    - `[x]` Test category creation/deletion
    - `[x]` Test note duplication
    - `[x]` Test trash restore/permanent delete
