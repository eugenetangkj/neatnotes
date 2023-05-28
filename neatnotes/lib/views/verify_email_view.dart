import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neatnotes/constants/colors.dart';
import 'package:neatnotes/services/auth/auth_exceptions.dart';
import 'package:neatnotes/services/auth/bloc/auth_bloc.dart';
import 'package:neatnotes/services/auth/bloc/auth_event.dart';
import 'package:neatnotes/services/auth/bloc/auth_state.dart';
import 'package:neatnotes/utilities/dialogs/error_dialog.dart';
import 'package:neatnotes/utilities/dialogs/verification_email_sent.dart';


class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {


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
                //Log the user out and navigate to login screen to login again
                //after email verification
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

  //Builds verify email title
  Widget buildVerifyEmailTitle() {
    return const Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
        child: Text(
          'Verify Email',
          style: TextStyle(fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
            fontSize: 28,
          ),
        ),
      ),
    );
  }

  //Builds verify email content
  Widget buildVerifyEmailContent() {
    return const Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(30, 20, 30, 20),
        child: Text(
          'We have sent you a verification email. Please verify your account, then log back in again.',
          style: TextStyle(fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 18,
            height: 1.5,
          ),
        ),
      ),
    );
  }


  //Builds did not receive message
  Widget buildDidNotReceiveMessage() {
    return const Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(30, 20, 30, 20),
        child: Text(
          'Did not receive?',
          style: TextStyle(fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            height: 1.5,
            color: lightGrayColour,
          ),
        ),
      ),
    );
  }


 
  //Builds send email verification button
  Widget buildSendEmailVerificationButton() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(100, 0, 100, 0),
      child: SizedBox(
        height: 40,
        child: ElevatedButton(
          onPressed: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            await Future.delayed(const Duration(milliseconds: 200));
            sendEmailVerificationButtonPressed();
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
          child: const Text('Send Email',
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

  //Runs when send email verification button is pressed
  void sendEmailVerificationButtonPressed() async {
    //Sends email verification again
    context.read<AuthBloc>().add(const AuthEventSendEmailVerification());
    showVerificationEmailSent(context);
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
          } else if (state.exception is GeneralAuthException) {
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

                          //Verify email title
                          buildVerifyEmailTitle(),

                          //Verify email body
                          buildVerifyEmailContent(),

                          //Did not receive email message
                          buildDidNotReceiveMessage(),
    
    
                         
    
                          //Register button
                          buildSendEmailVerificationButton(),
    
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