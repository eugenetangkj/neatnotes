import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neatnotes/constants/colors.dart';
import 'package:neatnotes/helpers/colors/generate_material_color.dart';
import 'package:neatnotes/helpers/loading/loading_screen.dart';
import 'package:neatnotes/services/auth/bloc/auth_bloc.dart';
import 'package:neatnotes/services/auth/bloc/auth_event.dart';
import 'package:neatnotes/services/auth/bloc/auth_state.dart';
import 'package:neatnotes/services/auth/firebase_auth_provider.dart';
import 'package:neatnotes/views/login_view.dart';

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
        } else {
          return const Scaffold(body: CircularProgressIndicator());
        }

      });
  }
    
}
