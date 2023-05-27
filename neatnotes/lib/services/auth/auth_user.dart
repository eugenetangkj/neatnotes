import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

//Represents a user who is using the application
@immutable
class AuthUser {
  final String id;
  final bool isEmailVerified;
  final String email;

  const AuthUser({required this.id, required this.isEmailVerified, required this.email});

  //Convenient method that uses a Firebase user to create a AuthUser that our application works with
  factory AuthUser.fromFirebase(User user) =>
    AuthUser(id: user.uid, isEmailVerified: user.emailVerified, email: user.email!,);
}