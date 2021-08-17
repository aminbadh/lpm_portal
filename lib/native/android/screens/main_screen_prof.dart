import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/native/android/screens/account_screen_prof.dart';
import 'package:lpm/native/android/screens/home_screen.dart';
import 'package:lpm/native/android/screens/notes_screen.dart';
import 'package:lpm/native/android/screens/prof_screen.dart';
import 'package:lpm/native/android/screens/settings_screen.dart';
import 'package:lpm/native/android/widgets/prof_drawer.dart';
import 'package:lpm/screens/tools/attendance_register/recent_registrations.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:lpm/utils/strings.dart';
import 'package:provider/provider.dart';

class MainScreenProf extends StatefulWidget {
  @override
  _MainScreenProfState createState() => _MainScreenProfState();
}

class _MainScreenProfState extends State<MainScreenProf> {
  ProfItems selected = ProfItems.home;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).scaffoldBackgroundColor,
          statusBarIconBrightness: themeChange.darkTheme ? Brightness.light : Brightness.dark,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          title(),
          style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 18),
        ),
        elevation: 0,
        iconTheme: IconThemeData(
          color: themeChange.darkTheme ? Constants.defaultTextColorD : Constants.defaultTextColorL,
        ),
      ),
      drawer: ProfDrawer(
        selectedTitle: title(),
        onSelected: (item) => setState(() => selected = item),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 1,
            color: themeChange.darkTheme ? Constants.dividerColorD : Constants.dividerColorL,
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: child(),
            ),
          ),
        ],
      ),
    );
  }

  String title() {
    switch (selected) {
      case ProfItems.home:
        return Strings.home;
      case ProfItems.account:
        return Strings.account;
      case ProfItems.notes:
        return Strings.notes;
      case ProfItems.attendanceRegister:
        return Strings.attRegister;
      case ProfItems.marksSaver:
        return Strings.marksSaver;
      case ProfItems.testsCalender:
        return Strings.testsCalendar;
      case ProfItems.settings:
        return Strings.settings;
      default:
        return null;
    }
  }

  Widget child() {
    switch (selected) {
      case ProfItems.home:
        return Container();
      case ProfItems.account:
        return AccountScreenProf();
      case ProfItems.notes:
        return Container();
      case ProfItems.attendanceRegister:
        return RecentAttendanceRegsContent(isAndroid: true);
      case ProfItems.marksSaver:
        return Container();
      case ProfItems.testsCalender:
        return Container();
      case ProfItems.settings:
        return SettingsScreen();
      default:
        return null;
    }
  }
}

class MainScreenProf2 extends StatefulWidget {
  final ProfItems selected;

  const MainScreenProf2({Key key, @required this.selected}) : super(key: key);

  @override
  _MainScreenProf2State createState() => _MainScreenProf2State();
}

class _MainScreenProf2State extends State<MainScreenProf2> {
  double scaleFactor = 1;
  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    Size size = MediaQuery.of(context).size;

    return AnimatedContainer(
      transform: Matrix4.translationValues(
          isDrawerOpen ? size.width / 1.5 : 0, isDrawerOpen ? size.height / 6.5 : 0, 0)
        ..scale(scaleFactor),
      duration: Duration(milliseconds: 250),
      margin: isDrawerOpen ? EdgeInsets.fromLTRB(6, 6, 6, 6) : EdgeInsets.zero,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.7),
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isDrawerOpen ? 10 : 0),
        child: GestureDetector(
          onTap: () {
            if (isDrawerOpen) switchState();
          },
          child: Scaffold(
            appBar: AppBar(
              backwardsCompatibility: false,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Theme.of(context).scaffoldBackgroundColor,
                statusBarIconBrightness: themeChange.darkTheme ? Brightness.light : Brightness.dark,
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text(
                title(),
                style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 18),
              ),
              elevation: 0,
              iconTheme: IconThemeData(
                color: themeChange.darkTheme
                    ? Constants.defaultTextColorD
                    : Constants.defaultTextColorL,
              ),
              leading: IconButton(
                icon: Icon(isDrawerOpen ? Icons.arrow_back : Icons.menu),
                splashRadius: 24,
                onPressed: () => switchState(),
              ),
            ),
            body: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 1,
                  color: themeChange.darkTheme ? Constants.dividerColorD : Constants.dividerColorL,
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: child(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void switchState() {
    isDrawerOpen
        ? setState(() {
            isDrawerOpen = false;
            scaleFactor = 1;
          })
        : setState(() {
            isDrawerOpen = true;
            scaleFactor = 0.8;
          });
  }

  String title() {
    switch (widget.selected) {
      case ProfItems.home:
        return Strings.home;
      case ProfItems.account:
        return Strings.account;
      case ProfItems.notes:
        return Strings.notes;
      case ProfItems.attendanceRegister:
        return Strings.attRegister;
      case ProfItems.marksSaver:
        return Strings.marksSaver;
      case ProfItems.testsCalender:
        return Strings.testsCalendar;
      case ProfItems.settings:
        return Strings.settings;
      default:
        return null;
    }
  }

  Widget child() {
    switch (widget.selected) {
      case ProfItems.home:
        return HomeScreen();
      case ProfItems.account:
        return AccountScreenProf();
      case ProfItems.notes:
        return NotesScreen();
      case ProfItems.attendanceRegister:
        return RecentAttendanceRegsContent(isAndroid: true);
      case ProfItems.marksSaver:
        return Container();
      case ProfItems.testsCalender:
        return Container();
      case ProfItems.settings:
        return SettingsScreen();
      default:
        return null;
    }
  }
}
