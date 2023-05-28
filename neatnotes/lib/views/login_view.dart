import 'package:flutter/material.dart';
import 'package:neatnotes/constants/colors.dart';

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
            //TODO: Navigate to logging in state
            print("Login button pressed");
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
                print("I do not have an account button pressed");
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

  // //Called when login button is pressed
  // void loginButtonClicked() async {
  //   String emailInput = _email.text;
  //   String passwordInput = _password.text;

  //   //Check if any fields are missing
  //   if (emailInput.isEmpty) {
  //     //Missing email input
  //     showErrorDialog(context, "Email field cannot be left blank.");
  //     return;
  //   } else if (passwordInput.isEmpty) {
  //     //Missing password input
  //     showErrorDialog(context, "Password field cannot be left blank.");
  //     return;
  //   }
    
  //   //Email and password inputs are present. Proceed to login attempt
  //   LoadingScreen().show(context: context, text: "Please wait while we log you in");
  //   bool isTimedOut = false;
  //   //Try to log user in, with max time limit for HTTP request to complete
  //   bool? result = await UserRepository().userLogin(emailInput, passwordInput)
  //     .timeout(
  //       const Duration(seconds: maxSecondsBeforeLoginTimeOut),
  //       onTimeout:() {
  //         isTimedOut = true;
  //         return false;
  //       }
  //     );

  //   if (result) {
  //     //Login successful. Navigate to projects list
  //     LoadingScreen().hide();
  //     navigateToProjectsList();
  //   } else {
  //     //Login unsuccessful.
  //     LoadingScreen().hide();
  //     switch (isTimedOut) {
  //       //Case 1: Timeout
  //       case (true):
  //         showErrorDialog(context, timeOutMessage);
  //         return;
  //       //Case 2: Cannot authenticate user
  //       case (false):
  //         showErrorDialog(context, "Please ensure that your email and password are correct.");
  //     }
  //   }
  // }

  // //Called when forgot password button is pressed
  // void forgotPasswordButtonClicked() {
  //   Navigator.of(context).push(MaterialPageRoute(
  //     builder: (context) => const ForgotPasswordView()
  //   )
  // );
  // }

  // //Navigate to projects list
  // void navigateToProjectsList() {
  //   Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(builder: (BuildContext context) {
  //       return const CustomNavigationBar();
  //     }),
  //     (route) => false);
  // }

  // //Builds login title widget
  // Widget buildLoginTitleWidget() {
  //   return const Align(
  //     alignment: AlignmentDirectional(-1, 0),
  //     child: Padding(
  //       padding: EdgeInsetsDirectional.fromSTEB(30, 40, 0, 0),
  //       child: Text(
  //         'Login',
  //         style: TextStyle(
  //             fontFamily: 'Roboto',
  //             fontWeight: FontWeight.w700,
  //             fontSize: 36,
  //         )
  //       ),
  //     ),
  //   );
  // }




  //Builds login button widget
  // Widget buildLoginButtonWidget() {
  //   return Padding(
  //     padding: const EdgeInsetsDirectional.fromSTEB(0, 80, 0, 0),
  //     child: SizedBox(
  //       width: 200,
  //       height: 60,
  //       child: TextButton(
  //         onPressed: () async {
  //           //Log the user in
  //           FocusManager.instance.primaryFocus?.unfocus();
  //           await Future.delayed(const Duration(milliseconds: 200));
  //           loginButtonClicked();
  //         },
  //         style: ButtonStyle(
  //           foregroundColor: MaterialStateProperty
  //               .resolveWith<Color?>(
  //                   (Set<MaterialState> states) {
  //             return Colors.white;
  //           }),
  //           backgroundColor: MaterialStateProperty
  //               .resolveWith<Color?>(
  //                   (Set<MaterialState> states) {
  //             return companyLogoRedColour;
  //           }),
  //           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //               RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(90),
  //               )
  //             ),
  //         ),
  //         child: const Text('LOGIN',
  //             style: TextStyle(
  //               fontFamily: 'Roboto',
  //               fontWeight: FontWeight.w700,
  //               fontSize: 20,
  //             )
  //           ),
  //       ),
  //     ),
  //   );
  // }

  //Builds forgot password widget
  // Widget buildForgotPasswordButtonWidget() {
  //   return Padding(
  //     padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
  //     child: SizedBox(
  //       height: 40,
  //       child: TextButton(
  //           onPressed: () async {
  //             //Force keyboard to close
  //             FocusManager.instance.primaryFocus
  //                 ?.unfocus();
  //             await Future.delayed(const Duration(
  //                 milliseconds: 200));
  //             //Navigate to forgot password screen
  //             forgotPasswordButtonClicked();
  //           },
  //           style: ButtonStyle(
  //             backgroundColor:
  //                 MaterialStateProperty
  //                     .resolveWith<Color?>(
  //                         (Set<MaterialState>
  //                             states) {
  //               return Colors.transparent;
  //             }),
  //           ),
  //           child: const Text(
  //             'Forgot Password?',
  //             style: TextStyle(
  //                 fontFamily: 'Roboto',
  //                 fontWeight: FontWeight.w400,
  //                 fontSize: 16,
  //                 color: companyLogoRedColour),
  //           )
  //         ),
  //     )
  //     );
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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


        
                // //Login title
                // buildLoginTitleWidget(),
        
                // //Email text field
                // buildEmailTextFieldWidget(),
        
                //Password text field
                // buildPasswordTextFieldWidget(),
              
                // //Login button
                // buildLoginButtonWidget(),
        
                // //Forgot password button
                // buildForgotPasswordButtonWidget(),
              ]
            ),
          ),
        ),
      )
    );
  }
}
