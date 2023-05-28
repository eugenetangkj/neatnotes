import 'package:flutter/material.dart';

//Solution adapted from medium.com/py-bits/turn-any-color-to-material-color-for-flutter-d8e8e037a837

/// Generates a custom [MaterialColor] based on input [alpha], [red], [green] and
/// [blue] and values.
MaterialColor getCustomMaterialColor(int alpha, int red, int green, int blue) {

  Color desiredColor = Color.fromARGB(alpha, red, green, blue);

  List strengths = <double>[.05];
  Map<int, Color> swatch = <int, Color>{};
  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  for (int i = 0; i < strengths.length; i = i + 1) {
    final double ds = 0.5 - strengths[i];
    swatch[(strengths[i] * 1000).round()] = Color.fromRGBO(
      red + ((ds < 0 ? red : (255 - red)) * ds).round(),
      green + ((ds < 0 ? green : (255 - green)) * ds).round(),
      blue + ((ds < 0 ? blue : (255 - blue)) * ds).round(),
      1,
    );
  }
  return MaterialColor(desiredColor.value, swatch);
}
