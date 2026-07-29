# Implementation Plan - Rich Text Rendering & Bug Fixes

This plan fixes the formatting symbols issue by implementing live Markdown rendering in the editor and resolves the selection-related crashes.

## User Review Required

> [!IMPORTANT]
> - **Live Styling**: The editor will now **actually show** Bold and Italic text while you type. The symbols (like `**`) will remain visible but will be styled alongside the text for a professional "Markdown" feel.
> - **Crash Fix**: I've identified the cause of the `RangeError` (it happens when you click formatting buttons without selecting the text area first) and will add safety guards.

## Proposed Changes

### 1. Rich Text Controller [NEW]
- **[MarkdownTextController](file:///U:/StudioProjects/mynote/lib/logic/services/markdown_text_controller.dart)**:
    - A custom `TextEditingController` that overrides `buildTextSpan`.
    - Uses Regular Expressions to detect `**bold**`, `*italic*`, and `• bullets`.
    - Applies `FontWeight.bold` and `FontStyle.italic` dynamically to the text.

### 2. Bug Fixes [MODIFY]
- **[NoteEditorPage](file:///U:/StudioProjects/mynote/lib/presentation/pages/note_editor_page.dart)**:
    - Update `_addBullet` and `_formatText` to check if `selection.baseOffset >= 0`.
    - If no selection exists, append the formatting to the end of the text instead of crashing.
    - Switch `_contentController` to use the new `MarkdownTextController`.

### 3. Dashboard Rendering [MODIFY]
- **[NoteCard](file:///U:/StudioProjects/mynote/lib/presentation/widgets/note_card.dart)**:
    - Use `MarkdownBody` from the `flutter_markdown` package to render the note preview.
    - This ensures that `**text**` appears as **Bold** on the home screen too.

## Verification Plan

### Manual Verification
1.  **Formatting Test**: Type `**Hello**`. Verify the word "Hello" appears bold in the editor.
2.  **Crash Test**: Open a new note and immediately click the "Bullet" button *without* clicking the title or content first. Verify the app no longer crashes.
3.  **Preview Test**: Save a note with bold text. Go to the home screen and verify the card shows the text as bold.
