import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/native/android/models/class.dart';
import 'package:lpm/native/android/screens/att_register_screen.dart';
import 'package:lpm/native/android/widgets/widgets.dart';
import 'package:lpm/native/utils/utils.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Theme(
      data: ThemeData(
        accentColor: themeChange.darkTheme ? Constants.primaryAccD : Constants.primaryAccL,
        dividerColor: themeChange.darkTheme ? Constants.dividerColorD : Constants.dividerColorL,
        textTheme: Theme.of(context).textTheme,
      ),
      child: ListView(
        children: [
          DrawerGroup(text: 'ACTIVITY'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(elevation: 4, child: ActivityCardContent()),
          ),
          DrawerGroup(text: 'DISCORD'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Join our Discord server',
                            style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 18),
                          ),
                        ),
                        ImageIcon(
                          AssetImage('assets/images/discord.png'),
                          size: 24,
                          color: Theme.of(context).textTheme.headline6.color.withOpacity(0.75),
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'We managed to get the students of our high school to join this '
                      'Discord server. By joining, you can easily stay in contact with '
                      'your students.',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(primary: Theme.of(context).accentColor),
                          // TODO: set a real url.
                          onPressed: () => launch('https://discord.gg/GgqzDfa'),
                          child: Text(
                            'JOIN NOW',
                            style: Theme.of(context).textTheme.bodyText1.copyWith(
                                  letterSpacing: 1,
                                  color: Theme.of(context).accentColor,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          DrawerGroup(text: 'EMAIL'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verify your email',
                      style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Please verify your email so we can reach out to you when we need to and '
                      'keep you updated.',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(primary: Theme.of(context).accentColor),
                          onPressed: () {
                            Utils.showSnackBar(context, 'Sending...', themeChange);
                            FirebaseAuth.instance.currentUser.sendEmailVerification().then((value) {
                              Utils.showSnackBar(context, 'Verification Email Sent', themeChange);
                            }, onError: (error) {
                              Utils.showSnackBar(context, error.message, themeChange);
                            });
                          },
                          child: Text(
                            'GET VERIFICATION EMAIL',
                            style: Theme.of(context).textTheme.bodyText1.copyWith(
                                  letterSpacing: 1,
                                  color: Theme.of(context).accentColor,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}

class ActivityCardContent extends StatefulWidget {
  @override
  _ActivityCardContentState createState() => _ActivityCardContentState();
}

class _ActivityCardContentState extends State<ActivityCardContent> {
  Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(Duration(minutes: 1), (Timer t) {
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Column(
      children: [
        SizedBox(height: 16),
        Text(
          _str(),
          style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 26),
        ),
        SizedBox(height: 12),
        Container(
          height: 74,
          width: 74,
          child: Stack(
            children: [
              Container(
                height: 74,
                width: 74,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: DateTime.now().minute / 60,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor.withOpacity(0.7)),
                ),
              ),
              Container(
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateTime.now().hour > 12
                            ? (DateTime.now().hour - 12).toString()
                            : DateTime.now().hour.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Colors.white, fontSize: 26),
                      ),
                      Text(
                        DateTime.now().hour > 12 ? 'PM' : 'AM',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Colors.white, fontSize: 12),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2),
        Divider(indent: 12, endIndent: 12),
        Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'NOW',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontSize: 12,
                  letterSpacing: 1.5,
                  color: themeChange.darkTheme ? Constants.greyD : Constants.greyL),
            ),
          ),
        ),
        SizedBox(height: 8),
        CurrentActivity(),
      ],
    );
  }

  String _str() {
    if (DateTime.now().hour < 12 && DateTime.now().hour >= 6) {
      return 'Good Morning';
    } else if (DateTime.now().hour >= 12 && DateTime.now().hour < 17) {
      return 'Good Afternoon';
    } else if (DateTime.now().hour >= 17 && DateTime.now().hour < 20) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }
}

class CurrentActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    DateTime date = DateTime.now();

    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('activity')
          .where('day', isEqualTo: date.weekday)
          .get(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<dynamic> data = snapshot.data.docs.first.get('data');
          Map<String, dynamic> act;
          data.forEach((element) {
            List<String> from = element['from'].split(':');
            List<String> to = element['to'].split(':');
            if (int.parse(from[0]) <= date.hour && date.hour < int.parse(to[0])) {
              act = element;
            }
          });
          if (act != null) {
            return Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 24),
                    Icon(Icons.class_, size: 20),
                    SizedBox(width: 16),
                    Text(
                      act['mClass'],
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 18, letterSpacing: 0.7),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    SizedBox(width: 24),
                    Icon(Icons.place, size: 20),
                    SizedBox(width: 16),
                    Text(
                      'class ${act['place']}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 18, letterSpacing: 0.7),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    SizedBox(width: 24),
                    Icon(Icons.timer, size: 20),
                    SizedBox(width: 16),
                    Text(
                      '${act['from']}  ➡  ${act['to']}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 17, letterSpacing: 0.7),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(primary: Theme.of(context).accentColor),
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FutureBuilder(
                            future: FirebaseFirestore.instance.doc(act['classPath']).get(),
                            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasData) {
                                Class _class;
                                try {
                                  _class = Class(
                                      docRef: snapshot.data.reference.path,
                                      data: snapshot.data.get('data'),
                                      absences: snapshot.data.get('absences'),
                                      students: snapshot.data.get('students'));
                                } catch (e) {
                                  _class = Class(
                                      docRef: snapshot.data.reference.path,
                                      data: snapshot.data.get('data'),
                                      students: snapshot.data.get('students'));
                                }
                                return AttendanceRegisterScreen(selectedClass: _class);
                              } else {
                                return Scaffold();
                              }
                            }),
                      )),
                      child: Text(
                        'REGISTER',
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              letterSpacing: 1,
                              color: Theme.of(context).accentColor,
                            ),
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                ),
              ],
            );
          } else {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
              child: Text(
                'You\'re Free',
                style: Theme.of(context).textTheme.headline6,
              ),
            );
          }
        } else {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                  themeChange.darkTheme ? Constants.primaryAccD : Constants.primaryAccL),
            ),
          );
        }
      },
    );
  }
}
