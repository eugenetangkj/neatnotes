import 'package:flutter/material.dart';
import 'package:neatnotes/utilities/dialogs/generic_dialog.dart';

Future<void> showVerificationEmailSent(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Verification Email Sent',
    content: "Please check your email to verify your account.",
    optionsBuilder: () => { 'OK': null, }
  );
}