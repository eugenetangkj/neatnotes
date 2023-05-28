import 'package:flutter/material.dart';

//Map button title to button return value
typedef DialogOptionBuilder<T> = Map<String, T?> Function();

//Optional because user can dismiss the dialog without having to specify a
//return value in Android devices
Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder,
}) {
  final options = optionsBuilder();
  return showDialog<T>(context: context, builder: (context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w700,
          fontSize: 24,
        )
      ),
      content: Text(content),
      actions: options.keys.map((optionTitle) {
        final value = options[optionTitle];
        return TextButton(
          onPressed: () {
            if (value != null) {
              Navigator.of(context).pop(value);
            } else {
              Navigator.of(context).pop();
            }
          },
          child: Text(optionTitle),
        );
      }).toList(),
    );
  });









}