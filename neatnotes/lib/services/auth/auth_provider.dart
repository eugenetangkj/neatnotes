

//Every provider that the application can work with should conform to this particular interface
//A provider provides the service for user authentication
import 'package:neatnotes/services/auth/auth_user.dart';

abstract class AuthProvider {
  //Initialise backend
  Future<void> initialize();

  //Get current auth user, may be null if no one is logged in
  AuthUser? get getCurrentUser;

  //Allows user to login
  Future<AuthUser> login({
    required String email,
    required String password,
  });

  //Allows user to be created
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  
  //Allows user to log out
  Future<void> logout();

  //Allows sending of email verification
  Future<void> sendEmailVerification();

  //Allows user to reset password
  Future<void> sendPasswordResetEmail({required String toEmail});



}
