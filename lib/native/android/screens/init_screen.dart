import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpm/native/android/screens/auth_screen.dart';
import 'package:lpm/native/android/screens/role_check_screen.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class InitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final user = Provider.of<User>(context);
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: 0)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Theme.of(context).scaffoldBackgroundColor,
              statusBarIconBrightness: themeChange.darkTheme ? Brightness.light : Brightness.dark,
            ),
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: user == null ? AuthScreen() : RoleCheckScreen(),
            ),
          );
        } else {
          return Scaffold();
        }
      },
    );
  }
}
