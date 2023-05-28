//A function that closes the loading screen, and indicates if the loading screen can be closed
import 'package:flutter/foundation.dart' show immutable;

typedef CloseLoadingScreen = bool Function();

//A function that updates the loading screen contents, indicating if the text can be updated
typedef UpdateLoadingScreen = bool Function(String text);

@immutable
class LoadingScreenController {
  final CloseLoadingScreen close;
  final UpdateLoadingScreen update;
  
  const LoadingScreenController({required this.close, required this.update});

}