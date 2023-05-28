import 'package:flutter/material.dart';
import 'package:neatnotes/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog<void>(
    context: context,
    title: 'Something Went Wrong',
    content: text,
    optionsBuilder: () => { 'OK': null, }
  );
}