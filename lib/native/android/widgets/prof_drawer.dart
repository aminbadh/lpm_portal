import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/native/android/screens/prof_screen.dart';
import 'package:lpm/native/android/widgets/widgets.dart';
import 'package:lpm/shared/data.dart';
import 'package:lpm/utils/strings.dart';

class ProfDrawer extends StatelessWidget {
  final String selectedTitle;
  final Function(ProfItems) onSelected;

  const ProfDrawer({Key key, this.selectedTitle, @required this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot doc = GlobalData.instance.get('UserDoc');
    String name = doc.get('firstName') + ' ' + doc.get('lastName');
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 150,
              color: Constants.primaryL,
              child: Row(
                children: [
                  SizedBox(width: 18),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12),
                      Container(
                        width: 64,
                        height: 64,
                        decoration: new BoxDecoration(
                          color: Constants.primaryAccL,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            color: Colors.black26,
                            child: Text(
                              name,
                              style: Theme.of(context).textTheme.headline6.copyWith(
                                    letterSpacing: 1.5,
                                    color: Colors.grey[200],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: Scrollbar(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerGroup(text: Strings.general),
                    DrawerItem(
                      text: Strings.home,
                      icon: Icons.home,
                      selected: selectedTitle == Strings.home,
                      onPressed: () {
                        Navigator.of(context).pop();
                        onSelected(ProfItems.home);
                      },
                    ),
                    DrawerItem(
                      text: Strings.account,
                      icon: Icons.person,
                      selected: selectedTitle == Strings.account,
                      onPressed: () {
                        Navigator.of(context).pop();
                        onSelected(ProfItems.account);
                      },
                    ),
                    DrawerGroup(text: Strings.tools),
                    DrawerItem(
                      text: Strings.notes,
                      icon: Icons.sticky_note_2,
                      selected: selectedTitle == Strings.notes,
                      onPressed: () {
                        Navigator.of(context).pop();
                        onSelected(ProfItems.notes);
                      },
                    ),
                    DrawerItem(
                      text: Strings.attRegister,
                      icon: Icons.event_note,
                      selected: selectedTitle == Strings.attRegister,
                      onPressed: () {
                        Navigator.of(context).pop();
                        onSelected(ProfItems.attendanceRegister);
                      },
                    ),
                    DrawerItem(
                      text: Strings.marksSaver,
                      icon: Icons.file_download_done,
                      selected: selectedTitle == Strings.marksSaver,
                      onPressed: () {
                        Navigator.of(context).pop();
                        onSelected(ProfItems.marksSaver);
                      },
                    ),
                    DrawerItem(
                      text: Strings.testsCalendar,
                      icon: Icons.event,
                      selected: selectedTitle == Strings.testsCalendar,
                      onPressed: () {
                        Navigator.of(context).pop();
                        onSelected(ProfItems.testsCalender);
                      },
                    ),
                    DrawerGroup(text: Strings.more),
                    DrawerItem(
                      text: Strings.settings,
                      icon: Icons.settings,
                      selected: selectedTitle == Strings.settings,
                      onPressed: () {
                        Navigator.of(context).pop();
                        onSelected(ProfItems.settings);
                      },
                    ),
                    DrawerItem(
                      text: Strings.about,
                      icon: Icons.info,
                      selected: selectedTitle == Strings.about,
                      onPressed: () {
                        Navigator.of(context).pop();
                        // onSelected(ProfItems.about);
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
    );
  }
}
