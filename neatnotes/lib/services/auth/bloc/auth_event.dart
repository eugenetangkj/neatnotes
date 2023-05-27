
import 'package:flutter/material.dart';

//An event that is received by the auth bloc which the auth bloc will react to, and
//eventually emit an auth state
@immutable
abstract class AuthEvent {
  const AuthEvent();
}

//Event of initialising the application
class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

//Event of logging into the app. Should contain every piece of information that the auth bloc needs
//to log in the user
class AuthEventLogin extends AuthEvent {
  final String email;
  final String password;

  const AuthEventLogin(this.email, this.password);
}

//Event of logging out of the app. Logout requires no information.
class AuthEventLogout extends AuthEvent {
  const AuthEventLogout();
}

//Event of sending an email verification. Auth bloc reacts to this by sending the email.
class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

//Event of registering a user. Auth bloc reacts to this by creating the user.
//Auth bloc needs email and password from the UI to create the new user
class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;

  const AuthEventRegister(this.email, this.password);
}

//Event of sending the user to the register view if the user indicates that he does
//not have an account yet. Does not need email and password because this event simply
//indicates that registration is required, but it does not handle the registration
class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

//Event that the user forgot password
//Auth bloc needs email to send recovery email
class AuthEventForgotPassword extends AuthEvent {
  final String? email;
  const AuthEventForgotPassword({this.email});
}