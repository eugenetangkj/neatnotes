//An auth provider that provides authentication functionality through Google sign in


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:neatnotes/firebase_options.dart';
import 'package:neatnotes/services/auth/auth_exceptions.dart';
import 'package:neatnotes/services/auth/auth_provider.dart';
import 'package:neatnotes/services/auth/auth_user.dart';

class GoogleAccAuthProvider implements AuthProvider {

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
  Future<AuthUser> login({required String email, required String password}) async {
    FirebaseAuth authInstance = FirebaseAuth.instance;

    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      //Credentials obtained. Try to sign user in
      try {
        final UserCredential userCredential = await authInstance.signInWithCredential(credential);
        User? user = userCredential.user;
        if (user != null) {
          return AuthUser.fromFirebase(user);
        } else {
          throw GenericAuthException();
        }
      }
      on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          throw WrongPasswordAuthException();
        } else if (e.code == 'invalid-credential') {
          throw UserNotFoundAuthException();
        } else {
          throw GenericAuthException();
        }
      } catch (e) {
        //Any other non-FirebaseAuthExceptions
        throw GenericAuthException();
      } 
    } else {
      throw NeverLogInException(); 
    }
  }

  @override
  Future<void> logout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      //User is currently logged in. Log him out.
      await GoogleSignIn().signOut();
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
}