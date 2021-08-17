import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lpm/constants.dart';

class Styles {
  static ThemeData webThemeData(bool isDarkTheme, BuildContext context) {
    return isDarkTheme
        ? ThemeData.dark().copyWith(
            primaryColor: Constants.primaryD,
            accentColor: Constants.primaryAccD,
            textTheme: TextTheme(
              headline4: GoogleFonts.ibmPlexSerif().copyWith(
                color: Constants.defaultTextColorD,
              ),
              headline5: GoogleFonts.ibmPlexSerif().copyWith(
                color: Constants.defaultTextColorD,
              ),
              headline6: GoogleFonts.ibmPlexSerif().copyWith(
                color: Constants.defaultTextColorD,
                fontSize: 18,
                height: 1.7,
              ),
              bodyText1: GoogleFonts.ibmPlexSerif().copyWith(
                color: Constants.defaultTextColorD,
              ),
              bodyText2: GoogleFonts.ibmPlexSerif().copyWith(
                color: Constants.defaultTextColorD,
              ),
            ),
          )
        : ThemeData.light().copyWith(
            primaryColor: Constants.primaryL,
            accentColor: Constants.primaryAccL,
            textTheme: TextTheme(
              headline4: GoogleFonts.ibmPlexSerif().copyWith(
                color: Constants.defaultTextColorL,
              ),
              headline5: GoogleFonts.ibmPlexSerif().copyWith(
                color: Constants.defaultTextColorL,
              ),
              headline6: GoogleFonts.ibmPlexSerif().copyWith(
                color: Constants.defaultTextColorL,
                fontSize: 18,
                height: 1.7,
              ),
              bodyText1: GoogleFonts.ibmPlexSerif().copyWith(
                color: Constants.defaultTextColorL,
              ),
              bodyText2: GoogleFonts.ibmPlexSerif().copyWith(
                color: Constants.defaultTextColorL,
              ),
            ),
          );
  }

  static ThemeData andThemeData(bool isDarkTheme, BuildContext context) {
    return isDarkTheme
        ? ThemeData.dark().copyWith(
            primaryColor: Constants.primaryD,
            accentColor: Constants.primaryAccD,
            textTheme: TextTheme(
              headline3: GoogleFonts.ibmPlexSerif().copyWith(
                color: Constants.defaultTextColorL,
              ),
              headline4: GoogleFonts.ibmPlexSerif().copyWith(
                color: Constants.defaultTextColorD,
              ),
              headline5: GoogleFonts.ibmPlexSerif().copyWith(
                color: Constants.defaultTextColorD,
              ),
              headline6: GoogleFonts.ibmPlexSerif().copyWith(
                color: Constants.defaultTextColorD,
              ),
              bodyText1: GoogleFonts.ibmPlexSerif().copyWith(
                color: Constants.defaultTextColorD,
              ),
              bodyText2: GoogleFonts.ibmPlexSerif().copyWith(
                color: Constants.defaultTextColorD,
              ),
            ),
          )
        : ThemeData.light().copyWith(
            primaryColor: Constants.primaryL,
            accentColor: Constants.primaryAccL,
            textTheme: TextTheme(
              headline3: GoogleFonts.ibmPlexSerif().copyWith(
                color: Constants.defaultTextColorL,
              ),
              headline4: GoogleFonts.ibmPlexSerif().copyWith(
                color: Constants.defaultTextColorL,
              ),
              headline5: GoogleFonts.ibmPlexSerif().copyWith(
                color: Constants.defaultTextColorL,
              ),
              headline6: GoogleFonts.ibmPlexSerif().copyWith(
                color: Constants.defaultTextColorL,
              ),
              bodyText1: GoogleFonts.ibmPlexSerif().copyWith(
                color: Constants.defaultTextColorL,
              ),
              bodyText2: GoogleFonts.ibmPlexSerif().copyWith(
                color: Constants.defaultTextColorL,
              ),
            ),
          );
  }
}
