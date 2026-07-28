import 'package:flutter/material.dart';

class ExitConfirmationDialog extends StatelessWidget {
  const ExitConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Unsaved Changes'),
      content: const Text('Do you want to save your changes before leaving?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false), // Discard
          child: const Text('Discard', style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, null), // Cancel (Stay)
          child: const Text('Stay'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true), // Save
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class DeleteAllConfirmationDialog extends StatelessWidget {
  const DeleteAllConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete all notes?'),
      content: const Text('This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete All', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
