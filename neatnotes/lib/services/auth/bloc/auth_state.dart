

//State that is received by the UI and acted upon
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:neatnotes/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;

  const AuthState({required this.isLoading, this.loadingText = 'Please wait a moment.'});
}

//Represents a state where the app is uninitialised. Firebase has yet to be initialised
//and authentication service is not set up. This state indicates to the UI that it needs to
//call some initialisation function.
class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required bool isLoading}) : super(isLoading: isLoading);
}

//Represents a state where the user is registering and the registration process could
//end up with an exception
class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({required this.exception, required bool isLoading})
    : super(isLoading: isLoading);
}

//Represents a state where the user is currently logged in
class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({required this.user, required bool isLoading})
    : super(isLoading: isLoading);
}

//Represents a state where the user does exist but has not verified his email
class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required bool isLoading})
    : super(isLoading: isLoading);
}

//Represents a state where the user is logged out. Has an exception because the
//there could be problems with logging in and it would transition into this state,
//carrying the exception along. Another possibility is that there are problems associated
//with logging out.
class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut({required this.exception, required bool isLoading, String? loadingText})
    : super(isLoading: isLoading, loadingText: loadingText);
  
  @override
  //Takes exception and isLoading properties into account when comparing 2 instances
  //of AuthStateLoggedOut
  List<Object?> get props => [exception, isLoading];
}

//Represents a state of the user having forgotten his password
class AuthStateForgotPassword extends AuthState {
  //3 possible states
  //State 1: Just landed at the forgot password page and has not done anything
  //State 2: User presses send recovery email but got exception
  //State 3: User presses send recovery email, no exception and is successful

  final Exception? exception;
  final bool hasSentEmail;

  const AuthStateForgotPassword({required this.exception, required this.hasSentEmail, required bool isLoading})
    : super(isLoading: isLoading);
}
