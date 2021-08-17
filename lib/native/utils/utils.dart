import 'package:flutter/material.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';

class Utils {
  static void showSnackBar(BuildContext context, String text, DarkThemeProvider themeChange) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          text,
          style: TextStyle(
              color: themeChange.darkTheme
                  ? Constants.textColorSnackBarD
                  : Constants.textColorSnackBarL),
        ),
        duration: Duration(minutes: 1),
      ),
    );
  }
}
