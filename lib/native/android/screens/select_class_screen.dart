import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lpm/components/error_text.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/native/android/models/class.dart';
import 'package:lpm/screens/tools/attendance_register/new_registration.dart';
import 'package:lpm/shared/data.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class SelectClassScreen extends StatefulWidget {
  // Create instance of the firestore service.
  final Function(Class) onSelected;

  SelectClassScreen({Key key, @required this.onSelected}) : super(key: key);

  @override
  _SelectClassScreenState createState() => _SelectClassScreenState();
}

class _SelectClassScreenState extends State<SelectClassScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final DocumentSnapshot _userDoc = GlobalData.instance.get('UserDoc');

  final Exception roleException = Exception("User's role isn't defined");

  List<Class> _classes;

  @override
  Widget build(BuildContext context) {
    return _classes == null
        ? FutureBuilder(
            future: _classesSnapshot(),
            builder: _classesBody,
          )
        : _dataBody();
  }

  Future<List<Class>> _classesSnapshot() {
    return _getQuery().get().then(_classesList);
  }

  List<Class> _classesList(QuerySnapshot snapshot) => snapshot.docs.map((doc) {
        try {
          return Class(
              docRef: doc.reference.path,
              data: doc.data()['data'],
              students: doc.get('students'),
              absences: doc.get('absences'));
        } catch (e) {
          return Class(
              docRef: doc.reference.path, data: doc.data()['data'], students: doc.get('students'));
        }
      }).toList();

  Query _getQuery() {
    // Create a CollectionReference for the classes collection.
    Query classes = _db.collectionGroup('classes');
    // Create a String that holds the user's role.
    String role = _userDoc.get('role');
    // Check the role of the user.
    if (role == 'Manager' || role == 'Developer') {
      return classes.orderBy('data.full');
    } else if (role == 'Teacher') {
      return classes.where('data.full', whereIn: _userDoc.get('classes'));
    } else {
      throw roleException;
    }
  }

  Widget _classesBody(context, AsyncSnapshot<List<Class>> snapshot) {
    if (snapshot.hasData) {
      _classes = snapshot.data;
      return _dataBody();
    } else if (snapshot.hasError) {
      final dynamic error = snapshot.error;
      print(error.toString());
      return Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: ErrorText(error.message),
        ),
      );
    } else {
      return Center(
        child: GettingDataText('Getting Data...'),
      );
    }
  }

  Widget _dataBody() {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    _classes.sort((a, b) => a.data['full'].compareTo(b.data['full']));
    return ListView.builder(
      itemCount: _classes.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, index) => ClipRRect(
        child: Column(
          children: [
            ListTile(
                trailing: Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: 18.0,
                  color: themeChange.darkTheme ? Constants.greyD : Constants.greyL,
                ),
                title: Text(
                  _classes[index].data['full'],
                  style: Theme.of(context).textTheme.headline6,
                ),
                onTap: () => widget.onSelected(_classes[index])),
            _divider(_classes, index),
          ],
        ),
      ),
    );
  }

  Widget _divider(_classes, index) {
    if (index < _classes.length - 1) {
      return _classes[index].data['level'] != _classes[index + 1].data['level']
          ? Divider(
              height: 1,
              endIndent: 20,
            )
          : SizedBox();
    } else {
      return SizedBox();
    }
  }
}
