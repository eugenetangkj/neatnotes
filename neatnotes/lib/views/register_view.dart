import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neatnotes/constants/colors.dart';
import 'package:neatnotes/services/auth/auth_exceptions.dart';
import 'package:neatnotes/services/auth/bloc/auth_bloc.dart';
import 'package:neatnotes/services/auth/bloc/auth_event.dart';
import 'package:neatnotes/services/auth/bloc/auth_state.dart';
import 'package:neatnotes/utilities/dialogs/error_dialog.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  //Used to access the text currently in the text field to pass into the bloc
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;

  //Used to censor password
  late bool _passwordVisible;
  late bool _confirmPasswordVisible;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    _passwordVisible = false;
    _confirmPasswordVisible = false;
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _passwordVisible = false;
    _confirmPasswordVisible = false;
    super.dispose();
  }


  //Builds back button
  Widget buildBackButton() {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(30, 20, 0, 0),
        child: SizedBox(
          height: 40,
          child: TextButton(
              onPressed: () async {
                //Force keyboard to close
                FocusManager.instance.primaryFocus
                    ?.unfocus();
                await Future.delayed(const Duration(
                    milliseconds: 200));
                //Navigate to login screen
                context.read<AuthBloc>().add(const AuthEventLogout());
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
                'Back',
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

  //Builds register title
  Widget buildRegisterTitle() {
    return const Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
        child: Text(
          'Register',
          style: TextStyle(fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
            fontSize: 28,
          ),
        ),
      ),
    );
  }

  //Builds email field
  Widget buildEmailTextField() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(30, 20, 30, 0),
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

  //Builds password field
  Widget buildPasswordTextField() {
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

  //Builds confirm password field
   Widget buildConfirmPasswordTextField() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(30, 30, 30, 0),
      child: TextFormField(
        controller: _confirmPassword,
        autofocus: false,
        obscureText: !_confirmPasswordVisible,
        decoration: InputDecoration(
            hintText: 'Confirm your password',
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
                      _confirmPasswordVisible =
                          !_confirmPasswordVisible;
                    }),
                focusNode:
                    FocusNode(skipTraversal: true),
                //Decide which icon to show depending on whether password is made visible
                child: Icon(
                  _confirmPasswordVisible
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

  //Builds register button
  Widget buildRegisterButton() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(100, 60, 100, 0),
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            await Future.delayed(const Duration(milliseconds: 200));
            registerButtonPressed();
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
          child: const Text('Register',
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

  //Runs when register button is pressed
  void registerButtonPressed() {
    //Get the current content in the text fields
    final email = _email.text;
    final password = _password.text;
    final confirmPassword = _confirmPassword.text;

    //Check whether password is the same as confirm password
    if (password != confirmPassword) {
      showErrorDialog(context, "Password and Confirm Password do not match.");
      return;
    }
    context.read<AuthBloc>().add(AuthEventRegister(email, password));
  }


  @override
  Widget build(BuildContext context) {
    //Listen to state changes
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, "Weak password. Must be at least 6 characters.");
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, "Email is already taken.");
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, "Please enter an email of valid format.");
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, "Registration error.");
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          //Top app bar
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                //Back button
                                buildBackButton(),
                              ],
                            ),
                          ),
    
    
                          //Email field
                          buildEmailTextField(),
    
                          //Password field
                          buildPasswordTextField(),
    
                          //Confirm password field
                          buildConfirmPasswordTextField(),
    
                          //Register button
                          buildRegisterButton(),
    
                        ]
                    ),
                  )
                )
              )
            )
          ),
    );
  }
}