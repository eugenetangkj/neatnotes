import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neatnotes/constants/colors.dart';
import 'package:neatnotes/services/auth/auth_exceptions.dart';
import 'package:neatnotes/services/auth/bloc/auth_bloc.dart';
import 'package:neatnotes/services/auth/bloc/auth_event.dart';
import 'package:neatnotes/services/auth/bloc/auth_state.dart';
import 'package:neatnotes/utilities/dialogs/error_dialog.dart';
import 'package:neatnotes/utilities/dialogs/recovery_email_sent.dart';


class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _email;

  @override
  void initState() {
    _email = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
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

  //Builds forgot password title
  Widget buildForgotPasswordTitle() {
    return const Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
        child: Text(
          'Forgot Password?',
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

  
  //Builds send recovery email button
  Widget buildSendRecoveryEmailButton() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(80, 60, 80, 0),
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            await Future.delayed(const Duration(milliseconds: 200));
            sendRecoveryEmailButtonPressed();
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
          child: const Text('Send Recovery Email',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
                fontSize: 18,
              )
            ),
        ),
      ),
    );
  }

  //Runs when register button is pressed
  void sendRecoveryEmailButtonPressed() {
    //Send recovery email  
    final email = _email.text;
    if (_email.text.isEmpty) {
      showErrorDialog(context, "Please fill up all the fields.");
      return;
    } else if (! (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email))) {
      //Invalid email format
      showErrorDialog(context, "Please enter an email address of valid format.");
      return;
    }
    context.read<AuthBloc>().add(AuthEventForgotPassword(email: email));
  }


  @override
  Widget build(BuildContext context) {
    //Listen to state changes
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _email.clear();
            await showRecoveryEmailSent(context);
          } else if (state.exception != null) {
            // await showErrorDialog(context, "Recovery email could not be sent. Please try again later.");
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
    
                          //Send recovery email button
                          buildSendRecoveryEmailButton(),
    
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