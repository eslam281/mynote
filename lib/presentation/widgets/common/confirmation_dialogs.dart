import 'package:flutter/material.dart';
import '../../../logic/l10n/app_localizations.dart';

class ExitConfirmationDialog extends StatelessWidget {
  const ExitConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n.translate('unsaved_changes')),
      content: Text(l10n.translate('save_confirm')),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false), // Discard
          child: Text(l10n.translate('discard'), style: const TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, null), // Cancel (Stay)
          child: Text(l10n.translate('stay')),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true), // Save
          child: Text(l10n.translate('save')),
        ),
      ],
    );
  }
}

class DeleteAllConfirmationDialog extends StatelessWidget {
  const DeleteAllConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n.translate('delete_all')),
      content: Text(l10n.translate('delete_all_confirm')),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.translate('cancel')),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(l10n.translate('delete_all'), style: const TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
