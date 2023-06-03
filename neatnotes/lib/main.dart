import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neatnotes/constants/colors.dart';
import 'package:neatnotes/constants/routes.dart';
import 'package:neatnotes/helpers/colors/generate_material_color.dart';
import 'package:neatnotes/helpers/loading/loading_screen.dart';
import 'package:neatnotes/services/auth/bloc/auth_bloc.dart';
import 'package:neatnotes/services/auth/bloc/auth_event.dart';
import 'package:neatnotes/services/auth/bloc/auth_state.dart';
import 'package:neatnotes/services/auth/firebase_auth_provider.dart';
import 'package:neatnotes/views/forgot_password_view.dart';
import 'package:neatnotes/views/login_view.dart';
import 'package:neatnotes/views/notes_view.dart';
import 'package:neatnotes/views/register_view.dart';
import 'package:neatnotes/views/verify_email_view.dart';

import 'views/create_update_note_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized;
  runApp(MaterialApp(
    title: 'Neat Notes',
    debugShowCheckedModeBanner: false, //Removes debug banner
    theme: ThemeData(
      primarySwatch: getCustomMaterialColor(
        darkBlueColourAlpha,
        darkBlueColourRed,
        darkBlueColourGreen,
        darkBlueColourBlue),
      fontFamily: 'Roboto',
    ),
    home: BlocProvider<AuthBloc>(
      //The bloc provider injects the AuthBloc into the context, so we can retrieve
      //the bloc from the context later on
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const HomePage(),
    ),
    routes: {
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    }
  ));
}


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    //Initialise the app
    context.read<AuthBloc>().add(const AuthEventInitialize());
    //The bloc consumer listens to side effects and state changes
    return BlocConsumer<AuthBloc, AuthState>(
      //In charge of side-effects based on states
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(context: context, text: state.loadingText ?? 'Please wait a moment.');
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        //Need to handle different states. Update UI according to state
        if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateLoggedIn) {
          return const NotesView();
        }
         else {
          return Scaffold(
              backgroundColor: lightBlueBackgroundColour,
              body: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    Text("Please hold on"),
                  ],
                ),
              )
            );
        }

      });
  }
    
}
