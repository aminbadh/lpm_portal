import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lpm/components/app_bar.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/models/registration.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class RecentAttendanceRegs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RecentAttendanceRegsContent(),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(24.0),
                child: MAppBar(
                  selected: MenuItem.tools,
                  onSelected: (menuItem) {
                    String routeName;
                    switch (menuItem) {
                      case MenuItem.aboutUs:
                        routeName = '/about-us';
                        break;
                      case MenuItem.news:
                        routeName = '/news';
                        break;
                      case MenuItem.contact:
                        routeName = '/contact';
                        break;
                      case MenuItem.account:
                        routeName = '/account';
                        break;
                      case MenuItem.home:
                        routeName = '/';
                        break;
                      case MenuItem.tools:
                        routeName = '/tools';
                        break;
                    }
                    Navigator.of(context).pushNamedAndRemoveUntil(routeName, (route) => false);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RecentAttendanceRegsContent extends StatelessWidget {
  final bool isAndroid;

  RecentAttendanceRegsContent({Key key, this.isAndroid}) : super(key: key);

  // Create instances of the firestore and auth services.
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create the used strings.
  final String _create = 'Add';

  // Used to get the stream of recent registrations.
  Stream<List<Registration>> _recentSnapshots() {
    return _db
        .collectionGroup('registrations')
        .where('professorId', isEqualTo: _auth.currentUser.uid)
        .orderBy('submitTime', descending: true)
        .limit(10)
        .snapshots()
        .map(_recentRegs);
  }

  // Used to convert the incoming data to Registration objects.
  List<Registration> _recentRegs(QuerySnapshot snapshot) => snapshot.docs
      .map((value) => Registration(
            professorName: value.get('professorName'),
            professorId: value.get('professorId'),
            subject: value.get('subject'),
            fromTime: value.get('fromTime'),
            toTime: value.get('toTime'),
            className: value.get('className'),
            docRef: value.reference.path,
            absences: value.get('absences'),
            submitTime: value.get('submitTime'),
          ))
      .toList();

  // Used to create the body of this page.
  Widget _body(AsyncSnapshot<List<Registration>> snapshot, BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    if (snapshot.hasData) {
      List<Registration> registrations = snapshot.data;
      return registrations.isEmpty
          ? NoDocumentsFound()
          : Theme(
              data: ThemeData(
                accentColor: themeChange.darkTheme ? Constants.primaryAccD : Constants.primaryAccL,
                dividerColor:
                    themeChange.darkTheme ? Constants.dividerColorD : Constants.dividerColorL,
                textTheme: Theme.of(context).textTheme,
              ),
              child: Scrollbar(
                child: ListView.builder(
                  padding: isAndroid
                      ? EdgeInsets.all(4)
                      : EdgeInsets.fromLTRB(16, Constants.mainOffset(context), 16, 8),
                  itemCount: registrations.length,
                  itemBuilder: (context, index) => RecentRegistrationListTile(registrations[index]),
                ),
              ),
            );
    } else if (snapshot.hasError) {
      print(snapshot.error.toString());
      return NoDocumentsFound();
    } else {
      return Center(
          child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _recentSnapshots(),
      builder: (context, snapshot) => Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).accentColor,
          tooltip: _create,
          child: Icon(
            Icons.add,
            color: Constants.defaultTextColorL,
          ),
          onPressed: () {
            Navigator.pushNamed(context, isAndroid ? '/classes' : '/tools/attendance/register/new');
          },
        ),
        body: _body(snapshot, context),
      ),
    );
  }
}

class RecentRegistrationListTile extends StatelessWidget {
  // Create an object for the Registration.
  final Registration _registration;

  // Create a constructor.
  RecentRegistrationListTile(this._registration);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        trailing: Icon(Icons.arrow_forward_ios_sharp, size: 18.0),
        title: Text(
          _registration.className,
          style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
        ),
        subtitle: Row(
          children: [
            Text(
              DateFormat('dd/MM/yyyy').format(
                new DateTime.fromMillisecondsSinceEpoch(_registration.submitTime),
              ),
            ),
            SizedBox(width: 16),
            Text('${_registration.fromTime} -> ${_registration.toTime}'),
          ],
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 400,
                        width: 400,
                        child: Card(
                          elevation: 24,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ListView(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'CLASS  :  ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(fontSize: 16.0),
                                    ),
                                    Text(
                                      '${_registration.className}  ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(fontSize: 16.0),
                                    ),
                                    Text(
                                      '${_registration.group}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(fontSize: 16.0),
                                    )
                                  ],
                                ),
                                SizedBox(height: 4.0),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'DATE  :  ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(fontSize: 16.0),
                                    ),
                                    Text(
                                      DateFormat('dd/MM/yyyy').format(
                                        new DateTime.fromMillisecondsSinceEpoch(
                                            _registration.submitTime),
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(fontSize: 16.0),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.0),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'TIME  :  ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(fontSize: 16.0),
                                    ),
                                    Text(
                                      '${_registration.fromTime} ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(fontSize: 16.0),
                                    ),
                                    Text(
                                      '-> ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(fontSize: 16.0),
                                    ),
                                    Text(
                                      '${_registration.toTime}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(fontSize: 16.0),
                                    )
                                  ],
                                ),
                                SizedBox(height: 4.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ABSENCES  :  ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(fontSize: 16.0),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Column(
                                        children: _students(context),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 16.0),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('EXIT'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          );
        },
      ),
    );
  }

  List<Widget> _students(BuildContext context) {
    return _registration.absences.isEmpty
        ? [
            Text(
              'There\'s no absences',
              style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 16.0),
            )
          ]
        : _registration.absences
            .map((name) => Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: 14.0,
                              height: 1.5,
                            ),
                      ),
                    ],
                  ),
                ))
            .toList();
  }
}

class NoDocumentsFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.event_note,
            size: 24.0,
            color: themeChange.darkTheme ? Constants.dividerColorL : Constants.dividerColorD,
          ),
          SizedBox(height: 8.0),
          Text(
            'Your recent documents will appear here',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}
