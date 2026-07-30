# Implementation Plan - Info & Contact Pages Migration

This plan migrates and modernizes the "About Me" and "Contact Us" pages from your previous project into MyNote Pro, adapting them to our current professional "Ocean Blue" design system.

## User Review Required

> [!IMPORTANT]
> - **Design Adaptation**: The pages will be completely redesigned using `SliverAppBar.large` and Bento-style cards to match the app's current aesthetic.
> - **Language**: The content will remain in Arabic as per your previous design, which fits perfectly with our new RTL support.

## Proposed Changes

### 1. Dependencies [MODIFY]
- **[pubspec.yaml](file:///U:/StudioProjects/mynote/pubspec.yaml)**: Add `url_launcher` for external links (GitHub, LinkedIn, Email).

### 2. New Pages [NEW]
- **[AboutUsPage](file:///U:/StudioProjects/mynote/lib/presentation/pages/about_us_page.dart)**:
    - Displays your profile, technical skills, and projects.
    - Uses a clean, card-based layout with the app's primary gradient.
- **[ContactUsPage](file:///U:/StudioProjects/mynote/lib/presentation/pages/contact_us_page.dart)**:
    - Lists contact methods (Email, GitHub, LinkedIn, Google Play).
    - Features interactive "Contact Cards" that launch external apps.

### 3. Navigation Update [MODIFY]
- **[AppDrawer](file:///U:/StudioProjects/mynote/lib/presentation/widgets/app_drawer.dart)**:
    - Add links to "من أنا" (About Me) and "تواصل معنا" (Contact Us) at the bottom of the menu.

## Verification Plan

### Manual Verification
1.  **Drawer Check**: Verify the new items appear in the side menu.
2.  **Visual Check**: Ensure the colors, fonts (Poppins), and card styles match the rest of the app.
3.  **Link Check**: Click on the GitHub and Email cards to verify they correctly open the respective apps/sites.
4.  **RTL Check**: Verify the pages align correctly from right-to-left when the system language is Arabic.
