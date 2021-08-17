import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:lpm/components/app_bar.dart';
import 'package:lpm/components/error_text.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/models/class.dart';
import 'package:lpm/models/registration.dart';
import 'package:lpm/shared/data.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

/// The [AttendanceOverviewScreen] widget is displayed when
/// the attendance overview is selected.
class AttendanceOverviewScreen extends StatefulWidget {
  @override
  _AttendanceOverviewScreenState createState() => _AttendanceOverviewScreenState();
}

class _AttendanceOverviewScreenState extends State<AttendanceOverviewScreen> {
  // Create a list tha holds the classes.
  List<Class> _classes;

  @override
  void dispose() {
    // Abandon the stream.
    _classes = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collectionGroup('classes')
              .orderBy('data.full')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth >= 800) {
                if (snapshot.hasData) {
                  // Update the classes list.
                  _classes = snapshot.data.docs.map(
                    (doc) {
                      try {
                        return Class(doc.reference.path, doc.data()['data'], doc.get('students1'),
                            doc.get('students2'), doc.get('absences'));
                      } catch (e) {
                        return doc.get('data')['level'] == '4L'
                            ? Class(doc.reference.path, doc.data()['data'], doc.get('students1'),
                                [], [])
                            : Class(doc.reference.path, doc.data()['data'], doc.get('students1'),
                                doc.get('students2'), []);
                      }
                    },
                  ).toList();
                  // Print a message.
                  print('Classes list retrieved.');
                  // Return the main list
                  return Scaffold(
                    body: Scrollbar(
                      child: ListView(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: MediaQuery.of(context).size.width / 15,
                        ),
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 104),
                              RecapWidget(),
                              AbsencesWidget(_classes),
                              AbsencesManagementWidget(_classes),
                              StudentsHistoryWidget(_classes),
                              StudentSearchWidget(_classes),
                              SoonWidget(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  // Print the error.
                  print(snapshot.error.toString());
                  // Display the error to the user.
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(snapshot.error.toString())));
                  // Return a container.
                  return Scaffold(body: Container());
                } else {
                  // Show a progress indicator.
                  return Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
              } else {
                return Scaffold(
                  body: Center(
                    child: Text(
                      'Please try running the app on a larger screen!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            letterSpacing: 0.5,
                            fontSize: 16.0,
                          ),
                    ),
                  ),
                );
              }
            });
          },
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
    );
  }
}

/// The [RecapWidget] displays a chart containing the number of absent students
/// in the recent 7 days, and gives the user the ability to access the recap
/// of all the absences in a selected date (using a date picker).
class RecapWidget extends StatelessWidget {
  // Create the used strings.
  final String _recap = 'Recap';
  final String _absences = 'ABSENCES';
  final String _selectADate = 'SELECT A DATE';

  // Used to get a charts series (makes the bar thinner).
  charts.Series<AbsModel, String> _series() => charts.Series<AbsModel, String>(
        id: 'Absences',
        domainFn: (AbsModel val, _) => intl.DateFormat('dd/MM/yyyy').format(
          DateTime.fromMillisecondsSinceEpoch(
            val.date,
          ),
        ),
        measureFn: (AbsModel val, _) => val.absences.length,
        fillColorFn: (AbsModel val, _) => charts.ColorUtil.fromDartColor(Colors.transparent),
        data: [],
      );

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    var axis = charts.NumericAxisSpec(
      renderSpec: charts.GridlineRendererSpec(
        labelStyle: charts.TextStyleSpec(fontSize: 10, color: charts.MaterialPalette.white),
        lineStyle:
            charts.LineStyleSpec(thickness: 0, color: charts.MaterialPalette.gray.shadeDefault),
      ),
    );

    var axis2 = charts.AxisSpec<String>(
      renderSpec: charts.GridlineRendererSpec(
        labelStyle: charts.TextStyleSpec(fontSize: 10, color: charts.MaterialPalette.white),
      ),
    );

    return DataContainer(
      [
        Text(
          _recap,
          style: Theme.of(context).textTheme.headline6.copyWith(
                fontSize: 16.0,
                color: themeChange.darkTheme ? Constants.greyD : Constants.greyL,
              ),
        ),
        SizedBox(height: 12.0),
        StreamBuilder(
          // Set the future (get the recent absences).
          stream: FirebaseFirestore.instance
              .collection('absences')
              .orderBy('date', descending: true)
              .limit(7)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              // Store the snapshot's data in a list.
              List<AbsModel> absences = snapshot.data.docs
                  .map((doc) => AbsModel(
                        doc.get('absences'),
                        doc.get('date'),
                      ))
                  .toList();
              // Sort the absences list.
              absences.sort((a, b) => a.date.compareTo(b.date));
              // Create a list of charts series.
              List<charts.Series<AbsModel, String>> seriesList = [
                _series(),
                _series(),
                _series(),
                charts.Series<AbsModel, String>(
                  id: 'Absences',
                  domainFn: (AbsModel val, _) => intl.DateFormat('dd/MM/yyyy').format(
                    DateTime.fromMillisecondsSinceEpoch(
                      val.date,
                    ),
                  ),
                  measureFn: (AbsModel val, _) => val.absences.length,
                  colorFn: (AbsModel _, __) {
                    return charts.MaterialPalette.indigo.makeShades(2)[1];
                  },
                  fillColorFn: (AbsModel _, __) {
                    return charts.MaterialPalette.indigo.makeShades(2)[1];
                  },
                  data: absences,
                ),
                _series(),
                _series(),
                _series(),
              ];
              return Column(
                children: [
                  Text(
                    _absences,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          letterSpacing: 1,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: themeChange.darkTheme
                              ? Constants.defaultTextColorD
                              : Constants.defaultTextColorL,
                        ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    child: themeChange.darkTheme
                        ? charts.BarChart(
                            seriesList,
                            primaryMeasureAxis: axis,
                            domainAxis: axis2,
                            animate: true,
                            vertical: true,
                            barGroupingType: charts.BarGroupingType.grouped,
                            defaultRenderer: new charts.BarRendererConfig(
                              cornerStrategy: const charts.ConstCornerStrategy(10),
                            ),
                          )
                        : charts.BarChart(
                            seriesList,
                            animate: true,
                            vertical: true,
                            barGroupingType: charts.BarGroupingType.grouped,
                            defaultRenderer: new charts.BarRendererConfig(
                              cornerStrategy: const charts.ConstCornerStrategy(10),
                            ),
                          ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              // Print the error.
              print(snapshot.error.toString());
              // Display the error.
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: ErrorText(snapshot.error.toString()),
                  ),
                ),
              );
            } else {
              // Show a progress indicator.
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: Padding(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  _selectADate,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        letterSpacing: 1,
                        color:
                            themeChange.darkTheme ? Constants.primaryAccD : Constants.primaryAccL,
                      ),
                ),
              ),
              onPressed: () async {
                // Show the date picker and store the coming value.
                final DateTime pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2022));
                if (pickedDate != null) {
                  // Store the date time variable.
                  GlobalData.instance.set('RECAP_DATE', pickedDate);
                  // Push the absences recap route.
                  Navigator.of(context).pushNamed('/tools/attendance/overview/recap');
                }
              },
            ),
          ],
        )
      ],
    );
  }
}

/// The [AbsModel] class is a model class that holds some data.
class AbsModel {
  final List absences;
  final int date;

  AbsModel(this.absences, this.date);
}

/// The [AbsencesWidget] allows the user to choose some settings
/// and then show them the absences registrations for these settings.
class AbsencesWidget extends StatefulWidget {
  // Create a list of classes.
  final List<Class> _classes;

  // Create a constructor.
  AbsencesWidget(this._classes);

  @override
  _AbsencesWidgetState createState() => _AbsencesWidgetState();
}

class _AbsencesWidgetState extends State<AbsencesWidget> {
  // Create a DateTime that holds the current date time.
  DateTime _dateTime = DateTime.now();

  // Create a bool variable.
  bool _isGr1 = true;

  // Create the used strings.
  final String _absencesRegister = 'Absences Register';
  final String _date = 'DATE :';
  final String _group = 'GROUP :';
  final String _gr1 = 'Group 1';
  final String _gr2 = 'Group 2';

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return DataContainer(
      [
        Text(
          _absencesRegister,
          style: Theme.of(context).textTheme.headline6.copyWith(
                fontSize: 16.0,
                color: themeChange.darkTheme ? Constants.greyD : Constants.greyL,
              ),
        ),
        SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Text(
                  _date,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(letterSpacing: 0.4),
                ),
                SizedBox(width: 10.0),
                Text(intl.DateFormat('dd/MM/yyyy').format(_dateTime)),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: 16.0,
                    color: themeChange.darkTheme ? Constants.greyD : Constants.greyL,
                  ),
                  splashRadius: 16.0,
                  onPressed: () async {
                    // Show a date picker and store the coming value.
                    final DateTime pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _dateTime,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2022));
                    if (pickedDate != null && pickedDate != _dateTime)
                      // Update the _dateTime variable.
                      setState(() => _dateTime = pickedDate);
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  _group,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(letterSpacing: 0.4),
                ),
                SizedBox(width: 8.0),
                Container(
                  width: 150.0,
                  child: RadioListTile(
                    value: true,
                    groupValue: _isGr1,
                    activeColor: Constants.primaryAccL,
                    title: Text(
                      _gr1,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    onChanged: (val) => setState(() => _isGr1 = val),
                  ),
                ),
                Container(
                  width: 150.0,
                  child: RadioListTile(
                    value: false,
                    groupValue: _isGr1,
                    activeColor: Constants.primaryAccL,
                    title: Text(
                      _gr2,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    onChanged: (val) => setState(() => _isGr1 = val),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 6.0),
        LayoutBuilder(builder: (context, constraints) {
          return GridView.builder(
            itemCount: widget._classes.length,
            physics: ClampingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (constraints.maxWidth / 150).round(), childAspectRatio: 150 / 60),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) => Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
              elevation: 0.0,
              margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Center(
                child: ListTile(
                  trailing: Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 18.0,
                    color: themeChange.darkTheme ? Constants.greyD : Constants.greyL,
                  ),
                  title: Text(
                    widget._classes[index].data['full'],
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  onTap: () {
                    // Store data.
                    GlobalData.instance.set('CLASS', widget._classes[index]);
                    GlobalData.instance.set('DATE', _dateTime);
                    GlobalData.instance.set('GROUP', _isGr1);
                    // Push the register-admin route.
                    Navigator.of(context).pushNamed('/tools/attendance/overview/registrations');
                  },
                ),
              ),
            ),
          );
        })
      ],
    );
  }
}

/// The [AbsencesManagementWidget] class is responsible of editing
/// the absences list of every class.
class AbsencesManagementWidget extends StatefulWidget {
  // Create a list of classes.
  final List<Class> _classes;

  // Create a constructor.
  AbsencesManagementWidget(this._classes);

  @override
  _AbsencesManagementWidgetState createState() => _AbsencesManagementWidgetState();
}

class _AbsencesManagementWidgetState extends State<AbsencesManagementWidget> {
  // Create a Class that holds the selected class.
  Class _selectedClass;

  var themeChange;

  // Create the used strings.
  final String _selectACLass = 'Please select a class.';
  final String _noAbsences = "There's no absences in the selected class.";
  final String _confirm = 'Confirm this operation';
  final String _conf1 = 'Do you want to remove ';
  final String _conf2 = ' from the absences list?';
  final String _no = 'NO';
  final String _yes = 'YES';
  final String _absencesMange = 'Absences Management';

  Widget _containerChild() {
    if (_selectedClass == null) {
      return Center(
        child: Text(_selectACLass),
      );
    } else {
      List<dynamic> absences = _selectedClass.absences;
      if (absences.isEmpty) {
        return Center(
          child: Text(_noAbsences),
        );
      } else {
        return ListView.builder(
          itemCount: _selectedClass.absences.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) => ListTile(
            title: Text(
              absences[index],
              style: Theme.of(context).textTheme.bodyText1,
            ),
            trailing: Icon(
              Icons.delete,
              color: themeChange.darkTheme ? Constants.greyD : Constants.greyL,
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      _confirm,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    content: Text(
                      _conf1 + absences[index] + _conf2,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          _no,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: Constants.primaryAccL),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            absences.removeAt(index);
                            Navigator.of(context).pop();
                            await FirebaseFirestore.instance
                                .doc(_selectedClass.docRef)
                                .update({'absences': absences});
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                width: MediaQuery.of(context).size.width / 2,
                                content: Text(
                                  e.toString(),
                                  style: TextStyle(
                                      color: themeChange.darkTheme
                                          ? Constants.textColorSnackBarD
                                          : Constants.textColorSnackBarL),
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          _yes,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: Constants.primaryAccL),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    themeChange = Provider.of<DarkThemeProvider>(context);

    return DataContainer(
      [
        Text(
          _absencesMange,
          style: Theme.of(context).textTheme.headline6.copyWith(
                fontSize: 16.0,
                color: themeChange.darkTheme ? Constants.greyD : Constants.greyL,
              ),
        ),
        SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: 400,
                child: ListView.builder(
                  itemCount: widget._classes.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) => Card(
                    margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: ListTile(
                      tileColor: _selectedClass == widget._classes[index]
                          ? themeChange.darkTheme
                              ? Colors.grey[700].withOpacity(0.5)
                              : Colors.grey[300]
                          : Colors.transparent,
                      trailing: Icon(
                        Icons.arrow_forward_ios_sharp,
                        size: 18.0,
                        color: themeChange.darkTheme ? Constants.greyD : Constants.greyL,
                      ),
                      title: Text(
                        widget._classes[index].data['full'],
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      onTap: () => setState(() => _selectedClass = widget._classes[index]),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[700]),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: _containerChild(),
              ),
            ),
          ],
        )
      ],
    );
  }
}

/// The [StudentsHistoryWidget] is in build...
class StudentsHistoryWidget extends StatefulWidget {
  final List<Class> _classes;

  StudentsHistoryWidget(this._classes);

  @override
  _StudentsHistoryWidgetState createState() => _StudentsHistoryWidgetState();
}

class _StudentsHistoryWidgetState extends State<StudentsHistoryWidget> {
  // Create the used objects.
  Class _selectedClass;
  dynamic _selectedStudent;
  var themeChange;

  Widget _studentsBody() {
    if (_selectedClass == null) {
      return Center(
        child: Text(
          'Please select a class.',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      );
    } else {
      List students = _selectedClass.students1 + _selectedClass.students2;
      students.sort((a, b) => a.compareTo(b));
      return ListView.builder(
        itemCount: students.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) => ListTile(
          tileColor: _selectedStudent == students[index]
              ? themeChange.darkTheme
                  ? Colors.grey[700].withOpacity(0.5)
                  : Colors.grey[300]
              : Colors.transparent,
          trailing: Icon(
            Icons.arrow_forward_ios_sharp,
            size: 18.0,
            color: themeChange.darkTheme ? Constants.greyD : Constants.greyL,
          ),
          title: Text(
            students[index],
            style: Theme.of(context).textTheme.bodyText1.copyWith(height: 2),
          ),
          onTap: () => setState(() => _selectedStudent = students[index]),
        ),
      );
    }
  }

  Widget _historyBody() {
    if (_selectedClass == null) {
      return Center(
        child: Text(
          'Please select a class.',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      );
    } else if (_selectedStudent == null) {
      return Center(
        child: Text(
          'Please select a student.',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      );
    } else {
      return FutureBuilder(
        future: FirebaseFirestore.instance
            .doc(_selectedClass.docRef)
            .collection('registrations')
            .where('absences', arrayContains: _selectedStudent)
            .orderBy('submitTime', descending: true)
            .limit(10)
            .get()
            .then((value) => value.docs
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
            if (registrations.isEmpty) {
              return Center(
                child: Text(
                  'This student has no absences.',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              );
            } else {
              return ListView.builder(
                itemCount: registrations.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    '${registrations[index].subject} - '
                    '${registrations[index].professorName}',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(height: 2),
                  ),
                  subtitle: Text('${registrations[index].fromTime} - '
                      '${registrations[index].toTime}'),
                  trailing: Text(intl.DateFormat('dd/MM/yyyy').format(
                      DateTime.fromMillisecondsSinceEpoch(registrations[index].submitTime))),
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
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    themeChange = Provider.of<DarkThemeProvider>(context);

    return DataContainer([
      Text(
        "Students History",
        style: Theme.of(context).textTheme.headline6.copyWith(
              fontSize: 16.0,
              color: themeChange.darkTheme ? Constants.greyD : Constants.greyL,
            ),
      ),
      Container(
          width: MediaQuery.of(context).size.width,
          height: 400,
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: widget._classes.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) => Card(
                    margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: ListTile(
                      tileColor: _selectedClass == widget._classes[index]
                          ? themeChange.darkTheme
                              ? Colors.grey[700].withOpacity(0.5)
                              : Colors.grey[300]
                          : Colors.transparent,
                      trailing: Icon(
                        Icons.arrow_forward_ios_sharp,
                        size: 18.0,
                        color: themeChange.darkTheme ? Constants.greyD : Constants.greyL,
                      ),
                      title: Text(
                        widget._classes[index].data['full'],
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      onTap: () => setState(() {
                        _selectedClass = widget._classes[index];
                        _selectedStudent = null;
                      }),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[700]),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    children: [
                      Expanded(child: _studentsBody()),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                flex: 2,
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[700]),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: _historyBody(),
                ),
              ),
            ],
          ))
    ]);
  }

  void selectClass(Class _class) {
    for (Class wClass in widget._classes) {
      if (wClass.data['full'] == _class.data['full'])
        setState(() {
          _selectedClass = wClass;
        });
    }
  }

  void selectStudent(String name) {
    for (String _name in _selectedClass.students1 + _selectedClass.students2) {
      if (name == _name)
        setState(() {
          _selectedStudent = _name;
        });
    }
  }
}

class StudentSearchWidget extends StatefulWidget {
  final List<Class> classes;

  StudentSearchWidget(this.classes);

  @override
  _StudentSearchWidgetState createState() => _StudentSearchWidgetState();
}

class _StudentSearchWidgetState extends State<StudentSearchWidget> {
  final TextEditingController _controller = TextEditingController();
  String nameValue = '';

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return DataContainer([
      Text(
        "Student Search",
        style: Theme.of(context).textTheme.headline6.copyWith(
              fontSize: 16.0,
              color: themeChange.darkTheme ? Constants.greyD : Constants.greyL,
            ),
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        height: 400,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: themeChange.darkTheme ? Colors.grey[600] : Colors.grey[300],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.grey[700],
                    ),
                    SizedBox(width: 12.0),
                    Expanded(
                      child: TextFormField(
                        textDirection: TextDirection.rtl,
                        controller: _controller,
                        cursorColor: themeChange.darkTheme ? Colors.grey[300] : Colors.grey[700],
                        decoration: InputDecoration.collapsed(
                          hintText: 'Student Name',
                        ),
                        onChanged: (value) => setState(() => nameValue = value),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _controller.clear();
                        setState(() => nameValue = '');
                      },
                      child: Text(
                        'Clear',
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              wordSpacing: 5,
                              fontWeight: FontWeight.w600,
                              color:
                                  themeChange.darkTheme ? Constants.primaryD : Constants.primaryL,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[600]),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: _searchBody(),
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _searchBody() {
    if (nameValue.length < 3) {
      return Center(
        child: Text('Students will be shown here.'),
      );
    } else {
      List<SearchStudent> studentsAll = getStudentsList();
      List<SearchStudent> students =
          studentsAll.where((item) => item.name.contains(nameValue)).toList();
      if (students.isEmpty) {
        return Center(
          child: Text('No students found with this name.'),
        );
      } else {
        return ListView.builder(
          itemCount: students.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                students[index].name,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              trailing: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(students[index].classN, style: Theme.of(context).textTheme.bodyText1),
                  Text(students[index].group, style: Theme.of(context).textTheme.bodyText2),
                ],
              ),
              onTap: () {},
            );
          },
        );
      }
    }
  }

  List<SearchStudent> getStudentsList() {
    List<SearchStudent> students = [];
    for (Class _class in widget.classes) {
      students
          .addAll(_class.students1.map((e) => SearchStudent(e, 'Group 1', _class.data['full'])));
      students
          .addAll(_class.students2.map((e) => SearchStudent(e, 'Group 2', _class.data['full'])));
    }
    return students;
  }
}

class SearchStudent {
  String name, group, classN;

  SearchStudent(this.name, this.group, this.classN);
}

/// The [DataContainer] returns a Card with a container and column.
class DataContainer extends StatelessWidget {
  // Create a list of widgets.
  final List<Widget> widgets;

  // Create a constructor.
  DataContainer(this.widgets);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12.0),
      child: Container(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
        ),
      ),
    );
  }
}

/// The [SoonWidget] class informs the user that more will be available soon.
class SoonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(18.0),
      child: Column(
        children: [
          Text(
            'More Items Will Be Available Soon...',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1.copyWith(letterSpacing: 0.7),
          ),
        ],
      ),
    );
  }
}
