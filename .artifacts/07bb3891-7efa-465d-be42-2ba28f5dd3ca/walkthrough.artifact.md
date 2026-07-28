# Walkthrough - Exit Safety & Trash Management

I have implemented features to protect your work and automate the cleanup of deleted notes.

## 🛡️ Exit Safety (Confirmation Dialog)
- **Prevent Data Loss**: You will no longer lose your notes by accidentally clicking the back button.
- **Smart Detection**: The app detects if you've made any changes (text, color, category, or attachments). If you have, a confirmation dialog will appear.
- **Save or Discard**: You can choose to **Save** your changes, **Discard** them, or **Stay** to continue editing.

## 🧹 Automatic Trash Cleanup
- **30-Day Auto-Purge**: Notes moved to the Trash will now be **automatically and permanently deleted after 30 days**. This keeps your device storage lean.
- **Clear Communication**: Added a professional information banner at the top of the Trash screen to remind you of the 30-day policy.

## 🛠️ Technical Improvements
- **Database Logic**: Added a `purgeDeletedNotes` method to `SqlDb` that calculates the 30-day threshold.
- **State Management**: The purge logic is triggered every time the app loads notes, ensuring your trash is always up-to-date.
- **Navigation Safety**: Utilized Flutter's `PopScope` for robust back-button handling in the editor.

> [!TIP]
> To test the safety feature: Open a note, change its color, and click the back arrow. You'll see the new confirmation dialog!
