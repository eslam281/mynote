# Tasks - Rich Text Rendering & Crash Fixes

- `[x]` Core Implementation
    - `[x]` Create `lib/logic/services/markdown_text_controller.dart`
- `[x]` Editor Safety & Enhancement
    - `[x]` Update `NoteEditorPage` with `MarkdownTextController`
    - `[x]` Guard `_formatText` and `_addBullet` against invalid selection
- `[x]` Dashboard UI Update
    - `[x]` Update `NoteCard` to use `MarkdownBody` for content preview
- `[x]` Verification
    - `[x]` Verify live styling in editor
    - `[x]` Verify no crash when clicking buttons with no focus
    - `[x]` Verify formatted preview on Home screen
