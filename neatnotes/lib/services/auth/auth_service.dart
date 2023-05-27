

//Service has an auth provider, and it uses the provider to provide the authentication service
import 'package:neatnotes/services/auth/auth_provider.dart';
import 'package:neatnotes/services/auth/auth_user.dart';
import 'package:neatnotes/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  //Constructor
  AuthService(this.provider);

  //Convenient method that creates an AuthService from a Firebase AuthProvider
  factory AuthService.createFromFirebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<void> initialize() {
    return provider.initialize();
  }

  @override
  Future<AuthUser> createUser({required String email, required String password,}) {
    return provider.createUser(email: email, password: password);
  }

  @override
  AuthUser? get getCurrentUser {
    return provider.getCurrentUser;
  }

  @override
  Future<AuthUser> login({required String email, required String password,}) {
    return provider.login(email: email, password: password);
  }

  @override
  Future<void> logout() {
    return provider.logout();
  }

  @override
  Future<void> sendEmailVerification() {
    return provider.sendEmailVerification();
  }

  @override
  Future<void> sendPasswordResetEmail({required String toEmail}) {
    return provider.sendPasswordResetEmail(toEmail: toEmail);
  }
  
}