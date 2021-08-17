import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';

class Constants {
  static final Color primaryL = Colors.indigo[700];
  static final Color primaryAccL = Colors.indigo[300];
  static final Color primaryD = Colors.indigo[200];
  static final Color primaryAccD = Colors.indigo[300];
  static final Color textColorSnackBarL = Colors.grey[200];
  static final Color textColorSnackBarD = Colors.grey[800];
  static final Color dividerColorL = Colors.grey[300];
  static final Color dividerColorD = Colors.grey[700];
  static final Color defaultTextColorL = ThemeData.light().textTheme.bodyText1.color;
  static final Color defaultTextColorD = ThemeData.dark().textTheme.bodyText1.color;
  static final Color greyL = Colors.grey[600];
  static final Color greyD = Colors.grey[300];

  static final int maxWidthMobile = 900;
  static final double bannerOffset = 34;

  static final String developer = 'Developer';
  static final String manager = 'Manager';
  static final String admin = 'Admin';
  static final String teacher = 'Teacher';
  static final String student = 'Student';

  static double mainOffset(BuildContext context) {
    return MediaQuery.of(context).size.width > 698 ? 128 : 164;
  }

  static bool isAndroid() {
    try {
      if (Platform.isAndroid) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static InputDecoration inputDecoration(String hintText, DarkThemeProvider themeChange) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: themeChange.darkTheme ? Colors.grey[900].withOpacity(0.3) : Colors.white,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: themeChange.darkTheme ? Colors.indigo.withOpacity(0.3) : Colors.indigo[100],
              width: 1.0)),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Constants.primaryAccL, width: 1.0)),
      focusedErrorBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.red[700], width: 1.0)),
      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1.0)),
    );
  }
}
