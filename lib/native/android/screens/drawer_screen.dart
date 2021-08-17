import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/native/android/screens/prof_screen.dart';
import 'package:lpm/native/android/widgets/widgets.dart';
import 'package:lpm/screens/tools/attendance_register/new_registration.dart';
import 'package:lpm/shared/data.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:lpm/utils/strings.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerScreen extends StatelessWidget {
  final String selectedTitle;
  final Function(ProfItems) onSelected;

  const DrawerScreen({Key key, this.selectedTitle, this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final _tooltipKey = new GlobalKey();
    Map<String, dynamic> nameMap = GlobalData.instance.get('UserDoc').get('name');
    String name = nameMap.values.elementAt(nameMap.keys.toList().indexOf('first')) +
        ' ' +
        nameMap.values.elementAt(nameMap.keys.toList().indexOf('last'));

    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          'assets/images/iii.jpg',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        name,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              letterSpacing: 1.5,
                              color: themeChange.darkTheme
                                  ? Constants.defaultTextColorD.withOpacity(0.8)
                                  : Constants.defaultTextColorL.withOpacity(0.7),
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                      ),
                    ),
                    Tooltip(
                      key: _tooltipKey,
                      message: 'Teacher',
                      child: GestureDetector(
                        onTap: () {
                          final dynamic tooltip = _tooltipKey.currentState;
                          tooltip.ensureTooltipVisible();
                          Future.delayed(Duration(seconds: 2), () {
                            // ignore: invalid_use_of_protected_member
                            _tooltipKey.currentState.deactivate();
                          });
                        },
                        child: ImageIcon(AssetImage('assets/images/teacher.png'),
                            color: themeChange.darkTheme
                                ? Constants.defaultTextColorD.withOpacity(0.8)
                                : Constants.defaultTextColorL.withOpacity(0.7),
                            size: 24),
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                ),
                Divider(),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: NoGlowScrollBehaviour(),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        DrawerGroup(text: Strings.general),
                        DrawerItem(
                          text: Strings.home,
                          icon: Icons.home,
                          selected: selectedTitle == Strings.home,
                          onPressed: () {
                            onSelected(ProfItems.home);
                          },
                        ),
                        DrawerItem(
                          text: Strings.account,
                          icon: Icons.person,
                          selected: selectedTitle == Strings.account,
                          onPressed: () {
                            onSelected(ProfItems.account);
                          },
                        ),
                        DrawerGroup(text: Strings.tools),
                        // DrawerItem(
                        //   text: Strings.notes,
                        //   icon: Icons.sticky_note_2,
                        //   selected: selectedTitle == Strings.notes,
                        //   onPressed: () {
                        //     onSelected(ProfItems.notes);
                        //   },
                        // ),
                        DrawerItem(
                          text: Strings.attRegister,
                          icon: Icons.event_note,
                          selected: selectedTitle == Strings.attRegister,
                          onPressed: () {
                            onSelected(ProfItems.attendanceRegister);
                          },
                        ),
                        DrawerItem(
                          text: 'Suggest A Tool',
                          icon: Icons.extension,
                          selected: false,
                          onPressed: () => launch('mailto:aminbadh@gmail.com'),
                        ),
                        // DrawerItem(
                        //   text: Strings.marksSaver,
                        //   icon: Icons.file_download_done,
                        //   selected: selectedTitle == Strings.marksSaver,
                        //   onPressed: () {
                        //     onSelected(ProfItems.marksSaver);
                        //   },
                        // ),
                        // DrawerItem(
                        //   text: Strings.testsCalendar,
                        //   icon: Icons.event,
                        //   selected: selectedTitle == Strings.testsCalendar,
                        //   onPressed: () {
                        //     onSelected(ProfItems.testsCalender);
                        //   },
                        // ),
                        DrawerGroup(text: Strings.more),
                        DrawerItem(
                          text: Strings.settings,
                          icon: Icons.settings,
                          selected: selectedTitle == Strings.settings,
                          onPressed: () {
                            onSelected(ProfItems.settings);
                          },
                        ),
                        DrawerItem(
                          text: Strings.about,
                          icon: Icons.info,
                          selected: selectedTitle == Strings.about,
                          onPressed: () {
                            // onSelected(ProfItems.about);
                            // TODO: create a screen for this.
                            showAboutDialog(
                                context: context,
                                applicationName: 'LPM',
                                applicationVersion: '1.0.0',
                                applicationIcon: Image.asset('assets/images/logo.png', height: 50),
                                children: [
                                  Text(
                                    'This app helps the students and the teachers of the pioneer high school in Monastir by a lot of helpful tools.',
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'This app is made by BADH',
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Copyright LPM 2021',
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                ]);
                          },
                        ),
                        DrawerItem(
                          text: Strings.signOut,
                          icon: Icons.logout,
                          selected: selectedTitle == Strings.signOut,
                          onPressed: () => FirebaseAuth.instance.signOut(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
