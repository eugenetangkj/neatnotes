import 'package:bloc/bloc.dart';
import 'package:neatnotes/services/auth/auth_provider.dart';
import 'package:neatnotes/services/auth/bloc/auth_event.dart';
import 'package:neatnotes/services/auth/bloc/auth_state.dart';

//Auth bloc takes in AuthEvents and react accordingly, emitting AuthStates that will
//be received by the UI
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  //Determines the type of provider that we are working with.
  //AuthBloc starts with an initial state of being uninitialised where it is currently loading Firebase
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialized(isLoading: true)) {
    //Handle different AuthEvents, producing different AuthStates accordingly

    //Event: The user needs to register for an account
    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(exception: null, isLoading: false));
    });

    //Event: The user wants to get the verification email
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      //When user presses the get verification email, the email is sent but there will not
      //be changes in the UI. So should just retain the current state
      emit(state);
    });

    //Event: The user wants to register for an account
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        emit(const AuthStateRegistering(exception: null, isLoading: true));
        await provider.createUser(email: email, password: password);
        await provider.sendEmailVerification();
        emit(const AuthStateRegistering(exception: null, isLoading: false));
        emit(const AuthStateNeedsVerification(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(exception: e, isLoading: false));
      }
    });

    //Event: The user wants to initialise the auth service
    on<AuthEventInitialize>((event, emit) async {
      //Initialise the provider
      await provider.initialize();
      final user = provider.getCurrentUser;
      if (user == null) {
        //Initialise the auth provider but there is no logged in user. Means logged out state.
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } else if (! user.isEmailVerified) {
        //Got logged in user but user's email is not verified.
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        //Got logged in user and user's email is verified
        emit(AuthStateLoggedIn(user: user, isLoading: false));
      }
    });

    //Event: The user wants to login
    on<AuthEventLogin>((event, emit) async {
      //When user wants to log in, he is currently logged out and is awaiting for verification
      emit(const AuthStateLoggedOut(exception: null, isLoading: true));
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.login(email: email, password: password);
        //Check if user's email is verified
        if (! user.isEmailVerified) {
          //Can log user in but his email is not verified
          emit(const AuthStateLoggedOut(exception: null, isLoading: false)); //Stops the loading
          await provider.sendEmailVerification(); //Send email verification
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          //Can log user in and his email is verified
          emit(const AuthStateLoggedOut(exception: null, isLoading: false)); //Stops the loading
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        }
      } on Exception catch (e) {
        //Cannot log user in, so it is logged out state
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });

    //Event: The user wants to log out
    on<AuthEventLogout>((event, emit) async {
      try {
        await provider.logout();
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });

    //Event: The user wants to reset password because he forgot his password
    on<AuthEventForgotPassword>((event, emit) async {
      //Navgiate to forgot password screen
      emit(const AuthStateForgotPassword(exception: null, hasSentEmail: false, isLoading: false));
      final email = event.email;
      if (email == null) {
        //User just entered the forgot password screen. Have not entered any email yet so no action needed.
        return;
      }

      //User entered an email and wants to actually send a recovery password email
      emit(const AuthStateForgotPassword(exception: null, hasSentEmail: false, isLoading: true));

      bool isEmailSent;
      Exception? exception;

      try {
        await provider.sendPasswordResetEmail(toEmail: email);
        isEmailSent = true;
        exception = null;
      } on Exception catch (e) {
        isEmailSent = false;
        exception = e;
      }

      emit(AuthStateForgotPassword(exception: exception, hasSentEmail: isEmailSent, isLoading: false));
    });











  }








}

