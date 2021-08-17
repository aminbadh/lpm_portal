import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lpm/components/error_text.dart';
import 'package:lpm/models/class.dart';
import 'package:lpm/models/registration.dart';
import 'package:lpm/screens/tools/attendance_register/new_registration.dart';

// No need.

class Registrations extends StatefulWidget {
  @override
  _RegistrationsState createState() => _RegistrationsState();
}

class _RegistrationsState extends State<Registrations> {
  // Create instance of the firestore service.
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create used objects.
  List<Class> _classes;
  Class _selClass;
  SettingsData _settingsData;

  void _onSave(context, data) {
    Navigator.of(context).pop();
    setState(() => _settingsData = data);
  }

  // Used to create the page's body.
  Widget _registrationsBody() {
    if (_selClass == null) {
      if (_classes == null || _classes.isEmpty) {
        return FutureBuilder(
          future: _classesSnap(),
          builder: (context, AsyncSnapshot<List<Class>> snapshot) {
            if (snapshot.hasData) {
              _classes = snapshot.data;
              _classes.map((e) => print(e.toString()));
              return ScrollConfiguration(
                behavior: NoGlowScrollBehaviour(),
                child: ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: _classes.length,
                  itemBuilder: (context, index) => Card(
                    margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: ListTile(
                      trailing: Icon(
                        Icons.arrow_forward_ios_sharp,
                        size: 18.0,
                        color: Colors.grey.shade600,
                      ),
                      title: Text(
                        snapshot.data[index].data['full'],
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      onTap: () => setState(() => _selClass = _classes[index]),
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error.toString());
              return Center(
                child: ErrorText(snapshot.error.toString()),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
      } else {
        return ScrollConfiguration(
          behavior: NoGlowScrollBehaviour(),
          child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: _classes.length,
              itemBuilder: (context, index) {
                final Class _class = _classes[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    trailing: Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 18.0,
                      color: Colors.grey.shade600,
                    ),
                    title: Text(
                      _class.data['full'],
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    onTap: () => setState(() => _selClass = _class),
                  ),
                );
              }),
        );
      }
    } else {
      return _registrationsTable();
    }
  }

  Widget _registrationsTable() {
    if (_settingsData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Please select the preferences.'),
            SizedBox(height: 8.0),
            ElevatedButton(
              child: Text('SELECT'),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => SettingsBody(_onSave, _settingsData),
                );
              },
            ),
          ],
        ),
      );
    } else {
      final DateTime selectedDate = _settingsData.date;
      final int todayFirst = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 00)
          .millisecondsSinceEpoch;
      final int todayLast = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 24)
          .millisecondsSinceEpoch;
      return FutureBuilder(
        future: _db
            .doc(_selClass.docRef)
            .collection('registrations')
            .where('submitTime', isGreaterThanOrEqualTo: todayFirst, isLessThanOrEqualTo: todayLast)
            .get()
            .then((_snapToRegsList)),
        builder: (context, AsyncSnapshot<List<Registration>> snapshot) {
          if (snapshot.hasData) {
            List<Registration> registrations = snapshot.data;
            registrations.sort((a, b) => a.submitTime.compareTo(b.submitTime));
            if (registrations.isEmpty) {
              return Center(
                child: Text('No Data To Show'),
              );
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: _columns(registrations),
                    rows: _rows(registrations),
                  ),
                ),
              );
            }
          } else if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Center(
              child: ErrorText(snapshot.error.toString()),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    }
  }

  List<DataColumn> _columns(List<Registration> registrations) {
    List<DataColumn> columns = [];
    columns.add(DataColumn(label: Text('Name'), numeric: false));
    registrations.forEach((registration) => columns.add(DataColumn(
        label: Text('${registration.fromTime} - ${registration.toTime}'),
        numeric: false,
        tooltip: '${registration.professorName} - ${registration.subject}')));
    return columns;
  }

  List<DataRow> _rows(List<Registration> registrations) {
    return _settingsData.isGroup1
        ? _selClass.students1.map((name) => DataRow(cells: _cells(name, registrations))).toList()
        : _selClass.students2.map((name) => DataRow(cells: _cells(name, registrations))).toList();
  }

  List<DataCell> _cells(String name, List<Registration> registrations) {
    List<DataCell> cells = [];
    cells.add(DataCell(Text(name)));
    cells.addAll(registrations.map(
      (reg) => DataCell(Text(
        reg.absences.contains(name) ? 'A' : '',
        textAlign: TextAlign.center,
      )),
    ));
    return cells;
  }

  List<Registration> _snapToRegsList(QuerySnapshot snapshot) => snapshot.docs
      .map((doc) => Registration(
            professorName: doc.get('professorName'),
            fromTime: doc.get('fromTime'),
            toTime: doc.get('toTime'),
            professorId: doc.get('professorId'),
            subject: doc.get('subject'),
            group: doc.get('group'),
            className: doc.get('className'),
            docRef: doc.reference.path,
            absences: doc.get('absences'),
            submitTime: doc.get('submitTime'),
          ))
      .toList();

  Future<List<Class>> _classesSnap() {
    return _db.collectionGroup('classes').orderBy('data.full').get().then(_snapshotToClassesList);
  }

  List<Class> _snapshotToClassesList(QuerySnapshot snapshot) => snapshot.docs.map((doc) {
        try {
          return Class(doc.reference.path, doc.data()['data'], doc.get('students1'),
              doc.get('students2'), doc.get('absences'));
        } catch (e) {
          return doc.get('data')['level'] == '4L'
              ? Class(doc.reference.path, doc.data()['data'], doc.get('students1'), [], [])
              : Class(doc.reference.path, doc.data()['data'], doc.get('students1'),
                  doc.get('students2'), []);
        }
      }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text('Registrations'),
        leading: _selClass == null
            ? null
            : IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => setState(() {
                  _selClass = null;
                  _settingsData = null;
                }),
                tooltip: 'Back',
              ),
        actions: _selClass != null
            ? [
                IconButton(
                  icon: Icon(Icons.subject),
                  tooltip: 'Settings',
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => SettingsBody(_onSave, _settingsData),
                    );
                  },
                ),
              ]
            : [],
      ),
      body: _registrationsBody(),
    );
  }
}

class SettingsBody extends StatefulWidget {
  final Function(BuildContext, SettingsData) _onSave;
  final SettingsData _data;

  SettingsBody(this._onSave, this._data);

  @override
  _SettingsBodyState createState() => _SettingsBodyState(_onSave, _data);
}

class _SettingsBodyState extends State<SettingsBody> {
  bool isGroup1 = true;

  DateTime currentDate = DateTime.now();

  final Function(BuildContext, SettingsData) _onSave;
  final SettingsData _data;

  _SettingsBodyState(this._onSave, this._data);

  @override
  void initState() {
    super.initState();
    if (_data != null) {
      isGroup1 = _data.isGroup1;
      currentDate = _data.date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(18.0),
      child: Column(
        children: [
          Text(
            'Settings',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'GROUP',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                fontSize: 16.0,
                                color: Colors.grey[600],
                              ),
                        ),
                      ),
                      RadioListTile(
                        value: true,
                        groupValue: isGroup1,
                        title: Text('Group 1'),
                        onChanged: (val) => setState(() => isGroup1 = val),
                      ),
                      RadioListTile(
                        value: false,
                        groupValue: isGroup1,
                        title: Text('Group 2'),
                        onChanged: (val) => setState(() => isGroup1 = val),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'DATE',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                fontSize: 16.0,
                                color: Colors.grey[600],
                              ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final DateTime pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: currentDate,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2022));
                              if (pickedDate != null && pickedDate != currentDate)
                                setState(() {
                                  currentDate = pickedDate;
                                });
                            },
                            child: Text('Select a Date'),
                          ),
                          Text(DateFormat('dd/MM/yyyy').format(currentDate)),
                        ],
                      ),
                      SizedBox(height: 32.0),
                      ButtonBar(
                        buttonMinWidth: 80.0,
                        children: [
                          TextButton(
                            child: Text('CANCEL'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          ElevatedButton(
                            child: Text('SAVE'),
                            onPressed: () => _onSave(context, SettingsData(isGroup1, currentDate)),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsData {
  bool isGroup1;
  DateTime date;

  SettingsData(this.isGroup1, this.date);
}
