import 'package:flutter/material.dart';
import 'package:lpm/screens/about/about_us_screen.dart';
import 'package:lpm/screens/account/account_screen.dart';
import 'package:lpm/screens/contact/contact_screen.dart';
import 'package:lpm/screens/errors/page_not_found.dart';
import 'package:lpm/screens/home/home_screen.dart';
import 'package:lpm/screens/news/news_screen.dart';
import 'package:lpm/screens/tools/attendance_overview/absences_recap.dart';
import 'package:lpm/screens/tools/attendance_overview/overview.dart';
import 'package:lpm/screens/tools/attendance_overview/register_admin.dart';
import 'package:lpm/screens/tools/attendance_register/new_registration.dart';
import 'package:lpm/screens/tools/attendance_register/recent_registrations.dart';
import 'package:lpm/screens/tools/tools_screen.dart';
import 'package:lpm/shared/data.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:lpm/utils/styles.dart';
import 'package:provider/provider.dart';

class LPMWeb extends StatefulWidget {
  @override
  _LPMWebState createState() => _LPMWebState();
}

class _LPMWebState extends State<LPMWeb> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme = await themeChangeProvider.darkThemePreference.getTheme();
  }

  MaterialPageRoute isLoggedIn(Widget screen, settings) {
    if (GlobalData.instance.get('UserDoc') == null) {
      return MaterialPageRoute(
        builder: (context) => PageNotFoundScreen(),
        settings: settings,
      );
    } else {
      return MaterialPageRoute(
        builder: (context) => screen,
        settings: settings,
      );
    }
  }

  MaterialPageRoute isProfessor(Widget screen, settings) {
    final doc = GlobalData.instance.get('UserDoc');
    if (doc == null) {
      return MaterialPageRoute(
        builder: (context) => PageNotFoundScreen(),
        settings: settings,
      );
    } else {
      final role = doc.get('role');
      if (role == 'Manager' || role == 'Developer' || role == 'Professor') {
        return MaterialPageRoute(
          builder: (context) => screen,
          settings: settings,
        );
      } else {
        return MaterialPageRoute(
          builder: (context) => PageNotFoundScreen(),
          settings: settings,
        );
      }
    }
  }

  MaterialPageRoute isAdmin(Widget screen, settings) {
    final doc = GlobalData.instance.get('UserDoc');
    if (doc == null) {
      return MaterialPageRoute(
        builder: (context) => PageNotFoundScreen(),
        settings: settings,
      );
    } else {
      final role = doc.get('role');
      if (role == 'Manager' || role == 'Developer' || role == 'Admin') {
        return MaterialPageRoute(
          builder: (context) => screen,
          settings: settings,
        );
      } else {
        return MaterialPageRoute(
          builder: (context) => PageNotFoundScreen(),
          settings: settings,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget child) {
          return MaterialApp(
            builder: (context, child) {
              return MediaQuery(
                  data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child);
            },
            title: 'LPM',
            theme: Styles.webThemeData(themeChangeProvider.darkTheme, context),
            onGenerateRoute: (RouteSettings settings) {
              if (settings.name == '/') {
                return MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                  settings: settings,
                );
              } else if (settings.name == '/about-us') {
                return MaterialPageRoute(
                  builder: (context) => AboutUsScreen(),
                  settings: settings,
                );
              } else if (settings.name == '/news') {
                return MaterialPageRoute(
                  builder: (context) => NewsScreen(),
                  settings: settings,
                );
              } else if (settings.name == '/contact') {
                return MaterialPageRoute(
                  builder: (context) => ContactScreen(),
                  settings: settings,
                );
              } else if (settings.name == '/account') {
                return isLoggedIn(AccountScreen(), settings);
              } else if (settings.name == '/tools') {
                return isLoggedIn(ToolsScreen(), settings);
              } else if (settings.name == '/tools/attendance/register/recent') {
                return isProfessor(RecentAttendanceRegs(), settings);
              } else if (settings.name == '/tools/attendance/register/new') {
                return isProfessor(NewRegistration(), settings);
              } else if (settings.name == '/tools/attendance/overview') {
                return isAdmin(AttendanceOverviewScreen(), settings);
              } else if (settings.name == '/tools/attendance/overview/recap') {
                final doc = GlobalData.instance.get('UserDoc');
                if (doc == null) {
                  return MaterialPageRoute(
                    builder: (context) => PageNotFoundScreen(),
                    settings: settings,
                  );
                } else {
                  final role = doc.get('role');
                  if ((role == 'Manager' || role == 'Developer' || role == 'Admin') &&
                      GlobalData.instance.get('RECAP_DATE') != null) {
                    return MaterialPageRoute(
                      builder: (context) => AttendanceRecap(),
                      settings: settings,
                    );
                  } else {
                    return MaterialPageRoute(
                      builder: (context) => PageNotFoundScreen(),
                      settings: settings,
                    );
                  }
                }
              } else if (settings.name == '/tools/attendance/overview/registrations') {
                final doc = GlobalData.instance.get('UserDoc');
                if (doc == null) {
                  return MaterialPageRoute(
                    builder: (context) => PageNotFoundScreen(),
                    settings: settings,
                  );
                } else {
                  final role = doc.get('role');
                  if ((role == 'Manager' || role == 'Developer' || role == 'Admin') &&
                      GlobalData.instance.get('CLASS') != null &&
                      GlobalData.instance.get('DATE') != null &&
                      GlobalData.instance.get('GROUP') != null) {
                    return MaterialPageRoute(
                      builder: (context) => AttendanceRegisterAdmin(),
                      settings: settings,
                    );
                  } else {
                    return MaterialPageRoute(
                      builder: (context) => PageNotFoundScreen(),
                      settings: settings,
                    );
                  }
                }
              } else {
                return MaterialPageRoute(
                  builder: (context) => PageNotFoundScreen(),
                  settings: settings,
                );
              }
            },
            initialRoute: '/',
          );
        },
      ),
    );
  }
}
