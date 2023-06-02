

//An auth provider that provides authentication functionality through the native Firebase
//email and password login
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:neatnotes/firebase_options.dart';
import 'package:neatnotes/services/auth/auth_exceptions.dart';
import 'package:neatnotes/services/auth/auth_provider.dart';
import 'package:neatnotes/services/auth/auth_user.dart';

class FirebaseAuthProvider implements AuthProvider {
  
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  }

  @override
  Future<AuthUser> createUser({required String email, required String password}) async {
    try {
      //Create a new Firebase user
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      final user = getCurrentUser;
      if (user != null) {
        //User is logged in
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        //Email already exists. Cannot create duplicate users
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == "invalid-email") {
        //User tried to register with an invalid email format
        throw InvalidEmailAuthException();
      } else if (e.code == "weak-password") {
        //User tried to register with a weak password
        throw WeakPasswordAuthException();
      } else {
        //Any other FirebaseAuthExceptions
        throw GenericAuthException();
      }
    } catch (e) {
      //Any other non-FirebaseAuthException exceptions
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get getCurrentUser {
    //Creates the AuthUser from the Firebase user
    final user = FirebaseAuth.instance.currentUser;
    if (user!= null) {
      //User is logged in
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> login({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      final user = getCurrentUser;
      if (user != null) {
        //User managed to log in successfully
        return user;
      } else {
        //User did not log in successfully but no exceptions were thrown
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        //Invalid login email format
        throw InvalidEmailAuthException();
      } else if (e.code == "user-not-found") {
        //User does not exist
        throw UserNotFoundAuthException();
      } else if (e.code == "wrong-password") {
        //User entered wrong login password
        throw WrongPasswordAuthException();
      } else {    
        //All other FirebaseAuthExceptions
        throw GenericAuthException();
      }
    } catch (e) {
      //Any other non-FirebaseAuthExceptions
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      //User is currently logged in. Log him out.
      await FirebaseAuth.instance.signOut();
    } else {
      //No user is currently logged in. Cannot perform log out operation
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      //User is logged in but email is not verified.
      await user.sendEmailVerification();
    } else {
      //User is not logged in. Cannot send email verification
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String toEmail}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'firebase_auth/invalid-email') {
        //User entered an invalid email address
        throw InvalidEmailAuthException();
      } else if (e.code == 'firebase_auth/user-not-found') {
        //No user is registered with the entered email address
        throw UserNotFoundAuthException();
      } else {
        //Any other FirebaseAuthExceptions
        throw GenericAuthException();
      }
    } catch (e) {
      //Any other non-FirebaseAuthExceptions
      throw GenericAuthException();
    }
  }
}



