import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lpm/components/app_bar.dart';
import 'package:lpm/components/error_text.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/models/class.dart';
import 'package:lpm/models/registration.dart';
import 'package:lpm/shared/data.dart';

class AttendanceRegisterAdmin extends StatefulWidget {
  @override
  _AttendanceRegisterAdminState createState() => _AttendanceRegisterAdminState();
}

class _AttendanceRegisterAdminState extends State<AttendanceRegisterAdmin> {
  // Create used objects.
  Class _class = GlobalData.instance.get('CLASS');
  DateTime _dateTime = GlobalData.instance.get('DATE');
  bool _isGr1 = GlobalData.instance.get('GROUP');
  String _selectedName = '';

  // Create the used strings.
  final String _noData = 'No Data Found';

  // Used to get the body of this page.
  Widget _body() {
    final int todayFirst =
        DateTime(_dateTime.year, _dateTime.month, _dateTime.day, 00).millisecondsSinceEpoch;
    final int todayLast =
        DateTime(_dateTime.year, _dateTime.month, _dateTime.day, 24).millisecondsSinceEpoch;
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .doc(_class.docRef)
          .collection('registrations')
          .where('submitTime', isGreaterThanOrEqualTo: todayFirst, isLessThanOrEqualTo: todayLast)
          .get()
          .then((snapshot) => snapshot.docs
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
              .toList()),
      builder: (context, AsyncSnapshot<List<Registration>> snapshot) {
        if (snapshot.hasData) {
          List<Registration> registrations = snapshot.data;
          registrations.sort((a, b) => a.submitTime.compareTo(b.submitTime));
          if (registrations.isEmpty) {
            return Center(
              child: Text(_noData),
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

  // Used to get the columns of the dataTable.
  List<DataColumn> _columns(List<Registration> registrations) {
    List<DataColumn> columns = [];
    columns.add(DataColumn(
        label: Text(
          'Name',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        numeric: false));
    registrations.forEach((registration) => columns.add(DataColumn(
        label: Text(
          '${registration.fromTime} - ${registration.toTime}',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        numeric: false,
        tooltip: '${registration.professorName} - ${registration.subject}')));
    return columns;
  }

  // Used to get the rows of the dataTable.
  List<DataRow> _rows(List<Registration> registrations) {
    List students = _isGr1 ? _class.students1 : _class.students2;
    students.sort((a, b) => a.compareTo(b));
    return students.map((name) => DataRow(cells: _cells(name, registrations))).toList();
  }

  // Used to get the cells of the dataRow.
  List<DataCell> _cells(String name, List<Registration> registrations) {
    List<DataCell> cells = [];
    cells.add(DataCell(
        Container(
            child: Text(
          name,
          style: TextStyle(
            height: 2.0,
          ),
        )),
        onTap: () =>
            setState(() => _selectedName == name ? _selectedName = '' : _selectedName = name)));
    cells.addAll(registrations.map(
      (reg) => DataCell(Center(
        child: reg.absences.contains(name)
            ? Icon(
                Icons.person_outline,
                color: Colors.red[700],
              )
            : Container(),
      )),
    ));
    return cells;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Scrollbar(
            child: ListView(
              children: [
                SizedBox(height: Constants.mainOffset(context) - 12),
                _body(),
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
}
