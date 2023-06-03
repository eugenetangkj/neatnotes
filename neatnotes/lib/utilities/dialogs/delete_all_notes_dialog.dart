import 'package:flutter/material.dart';
import 'package:neatnotes/utilities/dialogs/generic_dialog.dart';


Future<bool> showDeleteAllNotesDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete All Notes',
    content: 'Are you sure you want to delete all notes? This action is irreversible.',
    optionsBuilder: () => {
      'Cancel': false,
      'Confirm': true,
    }
    ).then((value) => value ?? false);
}