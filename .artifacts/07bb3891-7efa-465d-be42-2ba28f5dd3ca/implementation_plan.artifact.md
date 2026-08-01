# Implementation Plan - UI Visibility & Refinement

This plan focuses on fixing the visibility issues in the Side Drawer for Dark Mode, enhancing the category selection clarity, and further optimizing the Note Editor's bottom panel to feel less cramped.

## User Review Required

> [!IMPORTANT]
> - **Drawer Visibility**: I will remove all hardcoded "Black" colors from the side menu. It will now use the system's "onSurface" color, which automatically switches between Black (Light Mode) and White (Dark Mode).
> - **Category Clarity**: Selected categories will now have a bold border and a highly visible checkmark to distinguish them from unselected ones.
> - **Editor Layout**: I will redesign the bottom panel to be a **floating pill-shaped bar** instead of a full-width block. This will make it feel much lighter and less "cramped."

## Proposed Changes

### 1. Drawer Visibility Fix [MODIFY]
- **[AppDrawer](file:///U:/StudioProjects/mynote/lib/presentation/widgets/app_drawer.dart)**:
    - Update `_drawerItem` to use `Theme.of(context).colorScheme.onSurface` for text and icons when not selected.
    - Ensure the drawer background accurately reflects the Dark Mode theme.

### 2. Category Selection Enhancement [MODIFY]
- **[NoteEditorPage](file:///U:/StudioProjects/mynote/lib/presentation/pages/note_editor_page.dart)**:
    - Customize `ChoiceChip` with `selectedColor`, `labelStyle`, and `side` (border).
    - Use a contrasting color for the selected label to make it "pop."

### 3. Editor Bottom Panel Optimization [MODIFY]
- **[EditorBottomPanel](file:///U:/StudioProjects/mynote/lib/presentation/widgets/editor/editor_bottom_panel.dart)**:
    - Change the container into a **floating pill** with a smaller footprint.
    - Increase spacing between the attachment buttons and the color picker.
    - Reduce the overall height of the section.

### 4. Search Bar Alignment & Theme [MODIFY]
- **[HomeAppBar](file:///U:/StudioProjects/mynote/lib/presentation/widgets/home/home_app_bar.dart)**: Ensure the SearchBar text color is adaptive.

## Verification Plan

### Manual Verification
1.  **Drawer Test**: Switch to Dark Mode. Verify that "Archive", "Trash", and "Settings" are now bright white and clearly readable.
2.  **Category Selection**: Open the editor. Select a category. Verify that it is visually distinct (e.g., solid background vs outlined).
3.  **Cramped Section Test**: Verify that the new floating bottom panel feels more modern and leaves more space for writing.
4.  **Contrast Test**: Verify that all icons in the Note Editor (Lock, PDF, Save) remain visible across different backgrounds in Dark Mode.
