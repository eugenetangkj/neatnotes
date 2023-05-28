import 'package:flutter/material.dart';
import 'package:neatnotes/utilities/dialogs/generic_dialog.dart';

Future<void> showRecoveryEmailSent(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Recovery Email Sent',
    content: "Please check your email to reset your password.",
    optionsBuilder: () => { 'OK': null, }
  );
}