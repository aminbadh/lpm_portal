import 'package:flutter/material.dart';
import 'package:lpm/native/android/screens/sign_in_screen.dart';
import 'package:lpm/native/android/screens/sign_up_screen.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

enum AuthSteps { signIn, signUp }

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthSteps step = AuthSteps.signIn;
  DarkThemeProvider themeChange;

  @override
  Widget build(BuildContext context) {
    Widget child;
    themeChange = Provider.of<DarkThemeProvider>(context);

    switch (step) {
      case AuthSteps.signIn:
        child = SignInScreen(
          onSignUp: () => setState(() => step = AuthSteps.signUp),
        );
        break;
      case AuthSteps.signUp:
        child = SignUpScreen(
          onSignIn: () => setState(() => step = AuthSteps.signIn),
        );
        break;
    }

    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 400),
          child: child,
        ),
      ),
    );
  }
}
