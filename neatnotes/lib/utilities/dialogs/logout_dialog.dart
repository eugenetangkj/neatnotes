import 'package:flutter/material.dart';
import 'package:neatnotes/utilities/dialogs/generic_dialog.dart';


Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Logout',
    content: 'Are you sure you want to log out?',
    optionsBuilder: () => {
      'Cancel': false,
      'Confirm': true,
    }
    ).then((value) => value ?? false);
}