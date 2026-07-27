# Implementation Plan - Auth Bug Fix & RTL Support

This plan addresses the duplicate biometric prompt bug and implements full Arabic (RTL) and English (LTR) language support.

## User Review Required

> [!IMPORTANT]
> - **Authentication**: I will add a safeguard to prevent multiple biometric prompts from appearing at the same time.
> - **Language**: The app will now automatically adjust its alignment based on the phone's language (Arabic or English).

## Proposed Changes

### 1. Fix Authentication Logic [MODIFY]
- **[HomePage](file:///U:/StudioProjects/mynote/lib/presentation/pages/home_page.dart)**:
    - Introduce a `_isAuthenticating` flag in `_HomePageState` to ensure only one authentication process can run at a time.
    - Wrap the `onTap` logic in a check for this flag.

### 2. RTL & Language Support [MODIFY]
- **[pubspec.yaml](file:///U:/StudioProjects/mynote/pubspec.yaml)**:
    - Add `flutter_localizations` dependency.
- **[main.dart](file:///U:/StudioProjects/mynote/lib/main.dart)**:
    - Configure `MaterialApp` with `localizationsDelegates` and `supportedLocales` (Arabic and English).
    - This will enable automatic Right-to-Left (RTL) alignment when the system language is Arabic.

### 3. UI Alignment Polish [MODIFY]
- **[NoteCard](file:///U:/StudioProjects/mynote/lib/presentation/widgets/note_card.dart)**:
    - Ensure all text elements use `TextAlign.start` (default) to respect directionality.
- **[AppDrawer](file:///U:/StudioProjects/mynote/lib/presentation/widgets/app_drawer.dart)**:
    - Ensure the drawer correctly slides from the right in Arabic and left in English.

## Verification Plan

### Manual Verification
1.  **Auth Bug**: Rapidly tap a locked note multiple times. Verify that only **one** biometric prompt appears.
2.  **RTL Test**: Change phone language to Arabic. Verify that:
    - The drawer opens from the right.
    - Text is aligned to the right.
    - Icons (like back arrows) are mirrored correctly.
3.  **LTR Test**: Change phone language to English. Verify that the app reverts to left-alignment.
