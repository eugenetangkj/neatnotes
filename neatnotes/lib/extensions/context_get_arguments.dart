import 'package:flutter/material.dart' show BuildContext, ModalRoute;

//Allows us to pass information from one view to another, and retrieve it
extension GetArgument on BuildContext {
  T? getArgument<T>() {
    final modalRoute = ModalRoute.of(this); //this refers to the current BuildContext
    if (modalRoute != null) {
      final args = modalRoute.settings.arguments;
      if (args != null && args is T) {
        //Can get arguments and that argument is the type that we are expecting to extract
        return args as T;
      }
    }
    return null;
    
  }

}