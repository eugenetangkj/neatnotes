import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neatnotes/constants/colors.dart';
import 'package:neatnotes/services/auth/auth_exceptions.dart';
import 'package:neatnotes/services/auth/bloc/auth_event.dart';
import 'package:neatnotes/services/auth/bloc/auth_state.dart';
import 'package:neatnotes/utilities/dialogs/error_dialog.dart';

import '../services/auth/bloc/auth_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  //Used to access the text currently in the text fields
  late final TextEditingController _email;
  late final TextEditingController _password;

  //Used to determine if should censor the password or not
  late bool _passwordVisible;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _passwordVisible = false;
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordVisible = false;
    super.dispose();
  }

  //Builds login graphic widget
  Widget buildLoginGraphicWidget() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 60, 0, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            'assets/images/neatnotes_logo.png',
            width: 160,
            height: 90,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  } 

  //Builds email text field widget
  Widget buildEmailTextFieldWidget() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(30, 60, 30, 0),
      child: TextFormField(
        controller: _email,
        obscureText: false,
        decoration: InputDecoration(
          hintText: 'Enter your email address',
          hintStyle: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            color: lightGrayColour,
            fontWeight: FontWeight.normal,
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(
              Icons.mail_outline,
              color: lightGrayColour,
            ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: darkBlueColour,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  //Builds password text field widget
  Widget buildPasswordTextFieldWidget() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(30, 30, 30, 0),
      child: TextFormField(
        controller: _password,
        autofocus: false,
        obscureText: !_passwordVisible,
        decoration: InputDecoration(
            hintText: 'Enter your password',
            hintStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: lightGrayColour,
              fontWeight: FontWeight.normal,
            ),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.white,
                width: 2,
              ),
              borderRadius:
                  BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: darkBlueColour,
                width: 2,
              ),
              borderRadius:
                  BorderRadius.circular(20),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
              borderRadius:
                  BorderRadius.circular(20),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
              borderRadius:
                  BorderRadius.circular(20),
            ),
            prefixIcon: const Icon(
              Icons.lock_outlined,
              color: lightGrayColour,
            ),
            suffixIcon: InkWell(
                onTap: () => setState(() {
                      _passwordVisible =
                          !_passwordVisible;
                    }),
                focusNode:
                    FocusNode(skipTraversal: true),
                //Decide which icon to show depending on whether password is made visible
                child: Icon(
                  _passwordVisible
                      ? Icons.visibility
                      : Icons
                          .visibility_off_outlined,
                  size: 22,
                  color: darkBlueColour,
                )
            )
          ),
        keyboardType: TextInputType.visiblePassword,
      )
    );
  }

  //Builds forgot password widget
  Widget buildForgotPasswordButtonWidget() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(30, 10, 0, 0),
        child: SizedBox(
          height: 40,
          child: TextButton(
              onPressed: () async {
                //Force keyboard to close
                FocusManager.instance.primaryFocus
                    ?.unfocus();
                await Future.delayed(const Duration(
                    milliseconds: 200));
                //TODO: Navigate to forgot password screen
                print("Forgot password button pressed");
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty
                        .resolveWith<Color?>(
                            (Set<MaterialState>
                                states) {
                  return Colors.transparent;
                }),
              ),
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: lightGrayColour),
              )
            ),
        )
        ),
    );
  }

  //Builds login button widget
  Widget buildLoginButtonWidget() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
      child: SizedBox(
        width: 180,
        height: 50,
        child: ElevatedButton(
          onPressed: () async {
            //Log the user in
            FocusManager.instance.primaryFocus?.unfocus();
            await Future.delayed(const Duration(milliseconds: 200));
            loginButtonPressed();
           
          },
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty
                .resolveWith<Color?>(
                    (Set<MaterialState> states) {
              return Colors.black;
            }),
            backgroundColor: MaterialStateProperty
                .resolveWith<Color?>(
                    (Set<MaterialState> states) {
              return Colors.white;
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                )
              ),
          ),
          child: const Text('Login',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
                fontSize: 24,
              )
            ),
        ),
      ),
    );
  }

  //Builds sign in with google button widget
  Widget buildGoogleSignInButtonWidget() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
      child: SizedBox(
        width: 300,
        height: 60,
        child: OutlinedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )
            ),
            side: MaterialStateProperty.all(
              BorderSide.none,
            ),
          ),
          onPressed: () async {
            //TODO: Google sign in
            print("Google sign in button pressed");
          },

          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Image(
                  image: AssetImage("assets/images/google_logo.png"),
                  width: 30.0,
                  height: 30.0,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    'Sign in with Google',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  )
                )
              ]
            )
          )
        ,)
    )
  );
}

  //Builds I do not have an account button
  Widget buildNoAccountButtonWidget() {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
        child: SizedBox(
          height: 40,
          child: TextButton(
              onPressed: () async {
                //Force keyboard to close
                FocusManager.instance.primaryFocus
                    ?.unfocus();
                await Future.delayed(const Duration(
                    milliseconds: 200));
                //TODO: Navigate to forgot password screen
                context.read<AuthBloc>().add(AuthEventShouldRegister());
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty
                        .resolveWith<Color?>(
                            (Set<MaterialState>
                                states) {
                  return Colors.transparent;
                }),
              ),
              child: const Text(
                'I do not have an account',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: darkBlueColour),
              )
            ),
        )
      );
  }

 //Runs when the login button is pressed
 void loginButtonPressed() {
  //Get the contents in the text fields
  final email = _email.text;
  final password = _password.text;
  //Read in the auth bloc and convey the event to the auth bloc to react accordingly
  context.read<AuthBloc>().add(AuthEventLogin(email, password));
 }


  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      //Listens to state changes, displaying error messages accordingly
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, "User is not found.");
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Incorrect password.');
          } else if (state.exception is GeneralAuthException) {
            await showErrorDialog(context, "Authentication error.");
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          backgroundColor: lightBlueBackgroundColour,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  //Login Graphic
                  buildLoginGraphicWidget(),
    
                  //Email text field
                  buildEmailTextFieldWidget(),
    
                  //Password text field
                  buildPasswordTextFieldWidget(),
    
                  //Forgot password button
                  buildForgotPasswordButtonWidget(),
    
                   //Login button
                  buildLoginButtonWidget(),
    
                  //Google sign in button
                  buildGoogleSignInButtonWidget(),
    
                  //I do not have an account button
                  buildNoAccountButtonWidget(),
    
                ]
              ),
            ),
          ),
        )
      ),
    );
  }
}
