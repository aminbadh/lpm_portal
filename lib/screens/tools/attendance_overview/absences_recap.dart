import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lpm/components/app_bar.dart';
import 'package:lpm/components/error_text.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/models/absence.dart';
import 'package:lpm/models/student.dart';
import 'package:lpm/shared/data.dart';

class AttendanceRecap extends StatefulWidget {
  @override
  _AttendanceRecapState createState() => _AttendanceRecapState();
}

class _AttendanceRecapState extends State<AttendanceRecap> {
  // Get the selected date.
  final DateTime _dateTime = GlobalData.instance.get('RECAP_DATE');

  // Create used strings.
  final String _noData = 'No Data Found';

  // Used to get the registrations.
  Future<List<Absence>> _registrations() {
    DateTime dateTime = DateTime(_dateTime.year, _dateTime.month, _dateTime.day);
    return FirebaseFirestore.instance
        .collection('absences')
        .where('date', isEqualTo: dateTime.millisecondsSinceEpoch)
        .get()
        .then((value) => value.docs.map((doc) => _absence(doc)).toList());
  }

  // Used to convert a document to an absence.
  Absence _absence(DocumentSnapshot doc) {
    return Absence(
        doc.get('date'),
        doc.get('absences').map((student) {
          return Student(student['name'], student['num'], student['classN']);
        }).toList(),
        _list(doc, 'f8t9'),
        _list(doc, 'f9t10'),
        _list(doc, 'f10t11'),
        _list(doc, 'f11t12'),
        _list(doc, 'f12t13'),
        _list(doc, 'f13t14'),
        _list(doc, 'f14t15'),
        _list(doc, 'f15t16'),
        _list(doc, 'f16t17'),
        _list(doc, 'f17t18'));
  }

  // Used to get a list from a document.
  List _list(doc, String field) {
    try {
      return doc.get(field);
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Scrollbar(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                SizedBox(height: Constants.mainOffset(context)),
                FutureBuilder(
                  future: _registrations(),
                  builder: (context, AsyncSnapshot<List<Absence>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.isEmpty) {
                        return Center(
                          child: Text(_noData),
                        );
                      } else {
                        Absence absence = snapshot.data[0];
                        return Scrollbar(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              horizontalMargin: MediaQuery.of(context).size.width / 15,
                              columns: _columns(absence.absences),
                              rows: _rows(absence.absences, absence),
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
                ),
              ],
            ),
          ),
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

  // Used to get the columns of the dataTable.
  List<DataColumn> _columns(List absences) {
    List<DataColumn> columns = [];
    columns.add(DataColumn(
        label: Text('Number', style: Theme.of(context).textTheme.bodyText1), numeric: false));
    columns.add(DataColumn(
        label: Text('Name', style: Theme.of(context).textTheme.bodyText1), numeric: false));
    columns.add(DataColumn(
        label: Text('Class', style: Theme.of(context).textTheme.bodyText1), numeric: false));
    columns.add(DataColumn(
        label: Text('8 - 9', style: Theme.of(context).textTheme.bodyText1), numeric: false));
    columns.add(DataColumn(
        label: Text('9 - 10', style: Theme.of(context).textTheme.bodyText1), numeric: false));
    columns.add(DataColumn(
        label: Text('10 - 11', style: Theme.of(context).textTheme.bodyText1), numeric: false));
    columns.add(DataColumn(
        label: Text('11 - 12', style: Theme.of(context).textTheme.bodyText1), numeric: false));
    columns.add(DataColumn(
        label: Text('12 - 13', style: Theme.of(context).textTheme.bodyText1), numeric: false));
    columns.add(DataColumn(
        label: Text('13 - 14', style: Theme.of(context).textTheme.bodyText1), numeric: false));
    columns.add(DataColumn(
        label: Text('14 - 15', style: Theme.of(context).textTheme.bodyText1), numeric: false));
    columns.add(DataColumn(
        label: Text('15 - 16', style: Theme.of(context).textTheme.bodyText1), numeric: false));
    columns.add(DataColumn(
        label: Text('16 - 17', style: Theme.of(context).textTheme.bodyText1), numeric: false));
    columns.add(DataColumn(
        label: Text('17 - 18', style: Theme.of(context).textTheme.bodyText1), numeric: false));
    return columns;
  }

  // Used to get the rows of the dataTable.
  List<DataRow> _rows(List absences, Absence absence) {
    return absences.map((student) => DataRow(cells: _cells(student, absence))).toList();
  }

  // Used to get the cells of the dataRow.
  List<DataCell> _cells(student, Absence absence) {
    List<DataCell> cells = [];
    cells.add(DataCell(Text(student.num,
        style: TextStyle(
          height: 2.0,
        ))));
    cells.add(DataCell(Text(student.name,
        style: TextStyle(
          height: 2.0,
        ))));
    cells.add(DataCell(Text(student.classN,
        style: TextStyle(
          height: 2.0,
        ))));
    cells.add(DataCell(_icon(absence.f8t9.contains(student.name))));
    cells.add(DataCell(_icon(absence.f9t10.contains(student.name))));
    cells.add(DataCell(_icon(absence.f10t11.contains(student.name))));
    cells.add(DataCell(_icon(absence.f11t12.contains(student.name))));
    cells.add(DataCell(_icon(absence.f12t13.contains(student.name))));
    cells.add(DataCell(_icon(absence.f13t14.contains(student.name))));
    cells.add(DataCell(_icon(absence.f14t15.contains(student.name))));
    cells.add(DataCell(_icon(absence.f15t16.contains(student.name))));
    cells.add(DataCell(_icon(absence.f16t17.contains(student.name))));
    cells.add(DataCell(_icon(absence.f17t18.contains(student.name))));
    return cells;
  }

  Widget _icon(bool isAbsent) =>
      isAbsent ? Center(child: Icon(Icons.person_outline, color: Colors.red[700])) : Container();
}
