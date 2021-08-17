import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lpm/native/android/screens/att_register_screen.dart';
import 'package:lpm/native/android/screens/init_screen.dart';
import 'package:lpm/native/android/screens/new_note_screen.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:lpm/utils/styles.dart';
import 'package:provider/provider.dart';

class LPMAnd extends StatefulWidget {
  @override
  _LPMAndState createState() => _LPMAndState();
}

class _LPMAndState extends State<LPMAnd> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme = await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: FirebaseAuth.instance.authStateChanges(),
      child: ChangeNotifierProvider(
        create: (_) {
          return themeChangeProvider;
        },
        child: Consumer<DarkThemeProvider>(
          builder: (BuildContext context, value, Widget child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              builder: (context, child) {
                return MediaQuery(
                    data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                    child: child);
              },
              title: 'LPM',
              routes: {
                '/': (context) => InitScreen(),
                '/classes': (context) => AttendanceRegisterScreen(),
                '/notes/new': (context) => NewNoteScreen(),
              },
              theme: Styles.andThemeData(themeChangeProvider.darkTheme, context),
              initialRoute: '/',
            );
          },
        ),
      ),
    );
  }
}
