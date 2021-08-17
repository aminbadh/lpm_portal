import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lpm/components/app_bar.dart';
import 'package:lpm/components/error_text.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/models/class.dart';
import 'package:lpm/models/level.dart';
import 'package:lpm/models/student.dart';
import 'package:lpm/shared/data.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class NewRegistration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          NewRegistrationContent(),
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

class NewRegistrationContent extends StatefulWidget {
  final bool isAndroid;

  const NewRegistrationContent({Key key, this.isAndroid}) : super(key: key);

  @override
  _NewRegistrationContentState createState() => _NewRegistrationContentState();
}

class _NewRegistrationContentState extends State<NewRegistrationContent> {
  // Create instance of the firestore service.
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get the user's data.
  final DocumentSnapshot _userDoc = GlobalData.instance.get('UserDoc');

  // Create an exception to use it when the role in unknown.
  final Exception roleException = Exception("User's role isn't defined");

  // Create the used strings.
  final String _gettingData = 'Getting Data...';
  final String _selectLevel = 'Select A Level';
  final String _selectClass = 'Select A Class';
  final String _classText = 'Class';
  final String _timeText = 'Time';
  final String _studentsText = 'Students';
  final String _group1 = 'Group 1';
  final String _group2 = 'Group 2';
  final String _fromText = 'From';
  final String _toText = 'To';
  final String _saveButton = 'SAVE';

  // Create lists that will hold the retrieved data.
  List<Level> _levels;
  List<Class> _classes;

  // Create
  Level _selectedLevel;
  Class _selectedClass;

  //
  bool _isf = true;

  //
  bool _isLoading = false;

  //
  String _fromTime = '${DateTime.now().hour}:0';
  String _toTime = '${DateTime.now().hour + 1}:0';

  //
  List _absences = [];

  var themeChange;

  @override
  Widget build(BuildContext context) {
    themeChange = Provider.of<DarkThemeProvider>(context);

    if (_classes != null && _selectedClass != null) {
      return _registerBody(_selectedClass);
    } else if (_classes == null && _levels != null && _selectedLevel != null) {
      return FutureBuilder(
        future: _classesSnapshot(_selectedLevel),
        builder: _classesBody,
      );
    } else if (_levels == null) {
      return FutureBuilder(
        future: _levelsSnapshots(),
        builder: _levelsBody,
      );
    } else {
      return Container();
    }
  }

  Widget _registerBody(Class cls) {
    List<dynamic> students1 = cls.students1 ?? [];
    students1.sort((a, b) => a.compareTo(b));
    List<dynamic> students2 = cls.students2 ?? [];
    students2.sort((a, b) => a.compareTo(b));
    List<dynamic> classAbsences = cls.absences ?? [];
    return Scrollbar(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: widget.isAndroid ? 4 : 12),
        children: [
          SizedBox(height: widget.isAndroid ? 8 : Constants.mainOffset(context)),
          Card(
            margin: EdgeInsets.all(4.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _classText,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: themeChange.darkTheme ? Constants.greyD : Constants.greyL,
                          fontSize: 18.0,
                        ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          cls.data['full'],
                          style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16.0),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () => setState(() {
                                _isf = true;
                                _absences = [];
                              }),
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Row(
                                  children: <Widget>[
                                    Radio<bool>(
                                      activeColor: themeChange.darkTheme
                                          ? Constants.primaryD
                                          : Constants.primaryL,
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      groupValue: _isf,
                                      value: true,
                                      onChanged: (val) => setState(() {
                                        _isf = val;
                                        _absences = [];
                                      }),
                                    ),
                                    Text(_group1),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => setState(() {
                                _isf = false;
                                _absences = [];
                              }),
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Row(
                                  children: <Widget>[
                                    Radio<bool>(
                                      activeColor: themeChange.darkTheme
                                          ? Constants.primaryD
                                          : Constants.primaryL,
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      groupValue: _isf,
                                      value: false,
                                      onChanged: (val) => setState(() {
                                        _isf = val;
                                        _absences = [];
                                      }),
                                    ),
                                    Text(_group2),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.0)
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.all(4.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _timeText,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: themeChange.darkTheme ? Constants.greyD : Constants.greyL,
                          fontSize: 18.0,
                        ),
                  ),
                  SizedBox(height: 8.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              DateTime current = DateTime.now();
                              TimeOfDay time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                  hour: current.hour,
                                  minute: 0,
                                ),
                              );
                              if (time != null)
                                setState(() => _fromTime = '${time.hour}:${time.minute}');
                            },
                            child: Column(
                              children: [
                                SizedBox(height: 4),
                                Text(
                                  _fromText,
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  _fromTime,
                                  style: TextStyle(fontSize: 14.0),
                                ),
                                SizedBox(height: 4),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              DateTime current = DateTime.now();
                              TimeOfDay time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                  hour: current.hour,
                                  minute: 0,
                                ),
                              );
                              if (time != null)
                                setState(() => _toTime = '${time.hour}:${time.minute}');
                            },
                            child: Column(
                              children: [
                                SizedBox(height: 4),
                                Text(
                                  _toText,
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  _toTime,
                                  style: TextStyle(fontSize: 14.0),
                                ),
                                SizedBox(height: 4),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.all(4.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _studentsText,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: themeChange.darkTheme ? Constants.greyD : Constants.greyL,
                          fontSize: 18.0,
                        ),
                  ),
                  SizedBox(height: 4.0),
                  ScrollConfiguration(
                    behavior: NoGlowScrollBehaviour(),
                    child: ListView.builder(
                      itemCount: _isf ? students1.length : students2.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _isf
                            ? _studentListTile(
                                students1[index], classAbsences, index == students1.length - 1)
                            : _studentListTile(
                                students2[index], classAbsences, index == students2.length - 1);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      Map<String, dynamic> registration = {
                        'professorName': '${_userDoc['firstName']} ${_userDoc['lastName']}',
                        'professorId': _userDoc.id,
                        'subject': _userDoc['subject'],
                        'fromTime': _fromTime,
                        'toTime': _toTime,
                        'group': _isf ? 'Group 1' : 'Group 2',
                        'className': cls.data['full'],
                        'absences': _absences,
                        'submitTime': DateTime.now().millisecondsSinceEpoch,
                      };

                      // showDialog(
                      //     context: context,
                      //     builder: (context) => MakeSureDialog(
                      //           registration,
                      //           cls,
                      //           onSuccess,
                      //           onError,
                      //         ));

                      // Set loading to true.
                      setState(() => _isLoading = true);
                      // Save the registration.
                      FirebaseFirestore.instance
                          .doc(cls.docRef)
                          .collection('registrations')
                          .add(registration)
                          .then((value) {
                        // Create a list that holds the absent students.
                        List absentStudents;
                        if (cls.absences == null || cls.absences.isEmpty) {
                          // Make sure that the registration's absences list isn't null.
                          assert(registration['absences'] != null);
                          // Update the absent students list to the registration's absences list.
                          absentStudents = registration['absences'];
                        } else {
                          // Update the absent students list to the class's absences list.
                          absentStudents = cls.absences;
                          // Loop in the registration's absences list.
                          for (String name in registration['absences']) {
                            // Check if the absent students list contains the student name.
                            if (!absentStudents.contains(name)) {
                              // Add the student to the absent students list.
                              absentStudents.add(name);
                            }
                          }
                        }
                        // Update the class's absences list.
                        FirebaseFirestore.instance
                            .doc(cls.docRef)
                            .update({'absences': absentStudents}).then((value) {
                          // Create a DateTime that holds the current date.
                          DateTime current = new DateTime.now();
                          // Create a DateTime that holds today's date.
                          DateTime date = DateTime(
                            current.year,
                            current.month,
                            current.day,
                          );
                          // Get the absence document.
                          FirebaseFirestore.instance
                              .collection('absences')
                              .where('date', isEqualTo: date.millisecondsSinceEpoch)
                              .get()
                              .then((value) {
                            // Create a list that holds the fields' names.
                            List fields = [
                              'f8t9',
                              'f9t10',
                              'f10t11',
                              'f11t12',
                              'f12t13',
                              'f13t14',
                              'f14t15',
                              'f15t16',
                              'f16t17',
                              'f17t18'
                            ];
                            // Check if we get a result.
                            if (value.docs.isEmpty) {
                              // Create an absence map.
                              Map<String, dynamic> absence = {
                                'date': date.millisecondsSinceEpoch,
                                'absences': [],
                                'f8t9': [],
                                'f9t10': [],
                                'f10t11': [],
                                'f11t12': [],
                                'f12t13': [],
                                'f13t14': [],
                                'f14t15': [],
                                'f15t16': [],
                                'f16t17': [],
                                'f17t18': [],
                              };
                              // Create a list of students.
                              List<Map<String, dynamic>> students = [];
                              // Loop in the absences length.
                              for (int i = 0; i < registration['absences'].length; i++) {
                                // Add the student.
                                students.add(new Student(
                                        registration['absences'][i],
                                        studentIndex(cls, registration['group'],
                                            registration['absences'][i]),
                                        registration['className'])
                                    .toMap());
                                // Get the from time.
                                int from = getTime(registration['fromTime']);
                                // Get the to time.
                                int to = getTime(registration['toTime']);
                                // Get the range.
                                int range = to - from;
                                // Loop in the range.
                                for (int j = 0; j < range; j++) {
                                  // Get the list of the given time.
                                  List timeArray = getTimeArray(absence, fields[j + from - 8]);
                                  // Add the student name.
                                  timeArray.add(registration['absences'][i]);
                                  // Set the list.
                                  absence = setTimeArray(absence, timeArray, fields[j + from - 8]);
                                }
                              }
                              // Update the absences.
                              absence.update('absences', (value) => students);
                              // Add the absence object to the database.
                              FirebaseFirestore.instance.collection('absences').add(absence).then(
                                  (value) {
                                // Print a message.
                                print('Upload done with success!');
                                // Run the onSuccess function.
                                onSuccess();
                              }, onError: (error) {
                                // Print the error.
                                print(error.toString());
                                // Run the onError function.
                                onError(error);
                              });
                            } else {
                              // Create aDocumentSnapshot that holds the absence document.
                              DocumentSnapshot ds = value.docs[0];
                              // Create a Map that holds the document's data.
                              Map<String, dynamic> absence = ds.data();
                              // Get the absences list.
                              List<dynamic> students = absence['absences'];
                              // Loop in the absences length.
                              for (int i = 0; i < registration['absences'].length; i++) {
                                // Check if the student is already there.
                                if (containsStudents(students, registration['absences'][i])) {
                                  // Get the from time.
                                  int from = getTime(registration['fromTime']);
                                  // Get the to time.
                                  int to = getTime(registration['toTime']);
                                  // Get the range.
                                  int range = to - from;
                                  // Loop in the range.
                                  for (int j = 0; j < range; j++) {
                                    // Get the list of the given time.
                                    List timeArray = getTimeArray(absence, fields[j + from - 8]);
                                    // Check if the timeArray doesn't contain the student.
                                    if (!timeArray.contains(registration['absences'][i])) {
                                      // Add the student to the timeArray.
                                      timeArray.add(registration['absences'][i]);
                                      // Set the array.
                                      absence =
                                          setTimeArray(absence, timeArray, fields[j + from - 8]);
                                    }
                                  }
                                } else {
                                  // Add the student.
                                  students.add(new Student(
                                          registration['absences'][i],
                                          studentIndex(cls, registration['group'],
                                              registration['absences'][i]),
                                          registration['className'])
                                      .toMap());
                                  // Get the from time.
                                  int from = getTime(registration['fromTime']);
                                  // Get the to time.
                                  int to = getTime(registration['toTime']);
                                  // Get the range.
                                  int range = to - from;
                                  // Loop in the range.
                                  for (int j = 0; j < range; j++) {
                                    // Get the list of the given time.
                                    List timeArray = getTimeArray(absence, fields[j + from - 8]);
                                    // Check if the timeArray doesn't contain the student.
                                    if (!timeArray.contains(registration['absences'][i])) {
                                      // Add the student to the timeArray.
                                      timeArray.add(registration['absences'][i]);
                                      // Set the array.
                                      absence =
                                          setTimeArray(absence, timeArray, fields[j + from - 8]);
                                    }
                                  }
                                }
                              }
                              // Update the absences.
                              absence.update('absences', (value) => students);
                              // Add the absence object to the database.
                              FirebaseFirestore.instance
                                  .collection('absences')
                                  .doc(ds.id)
                                  .set(absence)
                                  .then((value) {
                                // Print a message.
                                print('Upload done with success!');
                                // Run the onSuccess function.
                                onSuccess();
                              }, onError: (error) {
                                // Print the error.
                                print(error.toString());
                                // Run the onError function.
                                onError(error);
                              });
                            }
                          }, onError: (error) {
                            // Print the error.
                            print(error.toString());
                            // Run the onError function.
                            onError(error);
                          });
                        }, onError: (error) {
                          // Print the error.
                          print(error.toString());
                          // Run the onError function.
                          onError(error);
                        });
                      }, onError: (error) {
                        // Print the error.
                        print(error.toString());
                        // Run the onError function.
                        onError(error);
                      });
                    },
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).accentColor,
              ),
              child: _isLoading
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[50]),
                          ),
                        ),
                        SizedBox(width: 12.0),
                        Text(
                          _saveButton,
                          style: TextStyle(color: Colors.white, letterSpacing: 2),
                        ),
                      ],
                    )
                  : Text(
                      _saveButton,
                      style: TextStyle(color: Colors.white, letterSpacing: 2),
                    ),
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  void onSuccess() {
    Navigator.of(context).pop();
  }

  void onError(error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        content: Text(
          error.message,
          style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  bool containsStudents(List<dynamic> students, String name) {
    for (int i = 0; i < students.length; i++) {
      dynamic student = students[i];
      if (student['name'] == name) {
        return true;
      }
    }
    return false;
  }

  int getTime(String time) {
    List<String> parts = time.split(":");
    print(parts[0]);
    return int.parse(parts[0]);
  }

  List getTimeArray(Map absence, String field) {
    switch (field) {
      case "f8t9":
        return absence['f8t9'];
      case "f9t10":
        return absence['f9t10'];
      case "f10t11":
        return absence['f10t11'];
      case "f11t12":
        return absence['f11t12'];
      case "f12t13":
        return absence['f12t13'];
      case "f13t14":
        return absence['f13t14'];
      case "f14t15":
        return absence['f14t15'];
      case "f15t16":
        return absence['f15t16'];
      case "f16t17":
        return absence['f16t17'];
      case "f17t18":
        return absence['f17t18'];
    }
    return null;
  }

  Map<String, dynamic> setTimeArray(Map<String, dynamic> absence, List timeArray, String field) {
    switch (field) {
      case "f8t9":
        absence.update('f8t9', (value) => timeArray);
        break;
      case "f9t10":
        absence.update('f9t10', (value) => timeArray);
        break;
      case "f10t11":
        absence.update('f10t11', (value) => timeArray);
        break;
      case "f11t12":
        absence.update('f11t12', (value) => timeArray);
        break;
      case "f12t13":
        absence.update('f12t13', (value) => timeArray);
        break;
      case "f13t14":
        absence.update('f13t14', (value) => timeArray);
        break;
      case "f14t15":
        absence.update('f14t15', (value) => timeArray);
        break;
      case "f15t16":
        absence.update('f15t16', (value) => timeArray);
        break;
      case "f16t17":
        absence.update('f16t17', (value) => timeArray);
        break;
      case "f17t18":
        absence.update('f17t18', (value) => timeArray);
        break;
    }
    return absence;
  }

  String studentIndex(Class mClass, String group, String name) {
    if (group == "Group 1") {
      return '${mClass.students1.indexOf(name) + 1}';
    } else {
      return '${mClass.students2.indexOf(name) + mClass.students1.length + 1}';
    }
  }

  Widget _studentListTile(name, List absences, bool isLast) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: () => setState(
                  () => _absences.contains(name) ? _absences.remove(name) : _absences.add(name)),
              child: Padding(
                padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    absences.contains(name)
                        ? Icon(
                            Icons.not_interested,
                            color: Colors.red[700],
                          )
                        : Container(),
                    Expanded(
                      child: Text(
                        name,
                        textAlign: TextAlign.end,
                        style: _studentTextStyle(name),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          isLast
              ? Container()
              : Divider(
                  height: 3,
                  thickness: 1,
                ),
        ],
      );

  TextStyle _studentTextStyle(name) => _absences.contains(name)
      ? TextStyle(decoration: TextDecoration.lineThrough, fontSize: 18.0, height: 1.5)
      : TextStyle(fontSize: 18.0, height: 1.5);

  Widget _classesBody(context, AsyncSnapshot<List<Class>> snapshot) {
    if (snapshot.hasData) {
      _classes = snapshot.data;
      _classes.sort((a, b) => a.data['number'].compareTo(b.data['number']));
      return Scrollbar(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            SizedBox(height: widget.isAndroid ? 8 : Constants.mainOffset(context) - 12),
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _selectClass,
                    style: Theme.of(context).textTheme.headline5.copyWith(letterSpacing: 1),
                  ),
                ],
              ),
            ),
            ListView.builder(
              itemCount: snapshot.data.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) => Card(
                margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  trailing: Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 18.0,
                    color: themeChange.darkTheme ? Constants.greyD : Constants.greyL,
                  ),
                  title: Text(
                    snapshot.data[index].data['full'],
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  onTap: () => setState(() => _selectedClass = _classes[index]),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (snapshot.hasError) {
      print(snapshot.error.toString());
      return Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: ErrorText(snapshot.error.toString()),
        ),
      );
    } else {
      return Center(
        child: GettingDataText(_gettingData),
      );
    }
  }

  Widget _levelsBody(context, AsyncSnapshot<List<Level>> snapshot) {
    if (snapshot.hasData) {
      _levels = snapshot.data;
      _levels.sort((a, b) => a.level.compareTo(b.level));
      return Scrollbar(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            SizedBox(height: widget.isAndroid ? 8 : Constants.mainOffset(context) - 12),
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _selectLevel,
                    style: Theme.of(context).textTheme.headline5.copyWith(letterSpacing: 1),
                  ),
                ],
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) => Card(
                margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  trailing: Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 18.0,
                    color: themeChange.darkTheme ? Constants.greyD : Constants.greyL,
                  ),
                  title: Text(
                    snapshot.data[index].level,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  onTap: () => setState(() => _selectedLevel = _levels[index]),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (snapshot.hasError) {
      print(snapshot.error.toString());
      return Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: ErrorText(snapshot.error.toString()),
        ),
      );
    } else {
      return Center(
        child: GettingDataText(_gettingData),
      );
    }
  }

  Future<List<Level>> _levelsSnapshots() {
    // Create a String that holds the user's role.
    final String role = _userDoc.get('role');
    // Check the role of the user.
    if (role == 'Manager' || role == 'Developer') {
      // Get all the documents in the levels collection.
      return _db.collection('levels').get().then(_levelsList);
    } else if (role == 'Professor') {
      // Get the documents that the prof teach.
      return _db
          .collection('levels')
          .where('level', whereIn: _userDoc.get('levels'))
          .get()
          .then(_levelsList);
    } else {
      // Throw an exception.
      throw roleException;
    }
  }

  List<Level> _levelsList(QuerySnapshot snapshot) =>
      snapshot.docs.map((value) => Level(value.get('level'), value.id)).toList();

  Future<List<Class>> _classesSnapshot(Level level) {
    return _getQuery(level).get().then((snapshot) => _classesList(snapshot, level));
  }

  List<Class> _classesList(QuerySnapshot snapshot, Level level) => snapshot.docs.map((doc) {
        try {
          return Class(doc.reference.path, doc.data()['data'], doc.get('students1'),
              doc.get('students2'), doc.get('absences'));
        } catch (e) {
          return level.level == '4L'
              ? Class(doc.reference.path, doc.data()['data'], doc.get('students1'), [], [])
              : Class(doc.reference.path, doc.data()['data'], doc.get('students1'),
                  doc.get('students2'), []);
        }
      }).toList();

  Query _getQuery(Level level) {
    // Create a CollectionReference for the classes collection.
    CollectionReference classes = _db.collection('levels').doc(level.docId).collection('classes');
    // Create a String that holds the user's role.
    String role = _userDoc.get('role');
    // Check the role of the user.
    if (role == 'Manager' || role == 'Developer') {
      return classes;
    } else if (role == 'Professor') {
      switch (level.level) {
        case '1S':
          return classes.where('data.number', whereIn: _userDoc.get('level1S'));
          break;
        case '2Sc':
          return classes.where('data.number', whereIn: _userDoc.get('level2Sc'));
          break;
        case '3M':
          return classes.where('data.number', whereIn: _userDoc.get('level3M'));
          break;
        case '3Sc':
          return classes.where('data.number', whereIn: _userDoc.get('level3Sc'));
          break;
        case '4L':
          return classes.where('data.number', whereIn: _userDoc.get('level4L'));
          break;
        case '4M':
          return classes.where('data.number', whereIn: _userDoc.get('level4M'));
          break;
        case '4Sc':
          return classes.where('data.number', whereIn: _userDoc.get('level4Sc'));
          break;
        case '4T':
          return classes.where('data.number', whereIn: _userDoc.get('level4T'));
          break;
        default:
          return throw Exception('The level is unknown');
      }
    } else {
      // Throw an exception.
      throw roleException;
    }
  }
}

class MakeSureDialog extends StatefulWidget {
  final Map<String, dynamic> registration;
  final Class cls;
  final Function onSuccess;
  final Function(dynamic) onError;

  MakeSureDialog(this.registration, this.cls, this.onSuccess, this.onError);

  @override
  _MakeSureDialogState createState() => _MakeSureDialogState();
}

class _MakeSureDialogState extends State<MakeSureDialog> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Make Sure'),
      content: Text('Once you upload this document you can\'t '
          'edit it (we are working on it)'),
      actions: [
        _isLoading
            ? Container(
                height: 10,
                width: 10,
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                ),
              )
            : Container(),
        SizedBox(width: 2.0),
        ElevatedButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            child: Text('CANCEL')),
        ElevatedButton(
          onPressed: _isLoading
              ? null
              : () {
                  // Set loading to true.
                  setState(() => _isLoading = true);
                  // Save the registration.
                  FirebaseFirestore.instance
                      .doc(widget.cls.docRef)
                      .collection('registrations')
                      .add(widget.registration)
                      .then((value) {
                    // Create a list that holds the absent students.
                    List absentStudents;
                    if (widget.cls.absences == null || widget.cls.absences.isEmpty) {
                      // Make sure that the registration's absences list isn't null.
                      assert(widget.registration['absences'] != null);
                      // Update the absent students list to the registration's absences list.
                      absentStudents = widget.registration['absences'];
                    } else {
                      // Update the absent students list to the class's absences list.
                      absentStudents = widget.cls.absences;
                      // Loop in the registration's absences list.
                      for (String name in widget.registration['absences']) {
                        // Check if the absent students list contains the student name.
                        if (!absentStudents.contains(name)) {
                          // Add the student to the absent students list.
                          absentStudents.add(name);
                        }
                      }
                    }
                    // Update the class's absences list.
                    FirebaseFirestore.instance
                        .doc(widget.cls.docRef)
                        .update({'absences': absentStudents}).then((value) {
                      // Create a DateTime that holds the current date.
                      DateTime current = new DateTime.now();
                      // Create a DateTime that holds today's date.
                      DateTime date = DateTime(
                        current.year,
                        current.month,
                        current.day,
                      );
                      // Get the absence document.
                      FirebaseFirestore.instance
                          .collection('absences')
                          .where('date', isEqualTo: date.millisecondsSinceEpoch)
                          .get()
                          .then((value) {
                        // Create a list that holds the fields' names.
                        List fields = [
                          'f8t9',
                          'f9t10',
                          'f10t11',
                          'f11t12',
                          'f12t13',
                          'f13t14',
                          'f14t15',
                          'f15t16',
                          'f16t17',
                          'f17t18'
                        ];
                        // Check if we get a result.
                        if (value.docs.isEmpty) {
                          // Create an absence map.
                          Map<String, dynamic> absence = {
                            'date': date.millisecondsSinceEpoch,
                            'absences': [],
                            'f8t9': [],
                            'f9t10': [],
                            'f10t11': [],
                            'f11t12': [],
                            'f12t13': [],
                            'f13t14': [],
                            'f14t15': [],
                            'f15t16': [],
                            'f16t17': [],
                            'f17t18': [],
                          };
                          // Create a list of students.
                          List<Map<String, dynamic>> students = [];
                          // Loop in the absences length.
                          for (int i = 0; i < widget.registration['absences'].length; i++) {
                            // Add the student.
                            students.add(new Student(
                                    widget.registration['absences'][i],
                                    studentIndex(widget.cls, widget.registration['group'],
                                        widget.registration['absences'][i]),
                                    widget.registration['className'])
                                .toMap());
                            // Get the from time.
                            int from = getTime(widget.registration['fromTime']);
                            // Get the to time.
                            int to = getTime(widget.registration['toTime']);
                            // Get the range.
                            int range = to - from;
                            // Loop in the range.
                            for (int j = 0; j < range; j++) {
                              // Get the list of the given time.
                              List timeArray = getTimeArray(absence, fields[j + from - 8]);
                              // Add the student name.
                              timeArray.add(widget.registration['absences'][i]);
                              // Set the list.
                              absence = setTimeArray(absence, timeArray, fields[j + from - 8]);
                            }
                          }
                          // Update the absences.
                          absence.update('absences', (value) => students);
                          // Add the absence object to the database.
                          FirebaseFirestore.instance.collection('absences').add(absence).then(
                              (value) {
                            // Print a message.
                            print('Upload done with success!');
                            // Pop the dialog.
                            Navigator.of(context).pop();
                            // Run the onSuccess function.
                            widget.onSuccess();
                          }, onError: (error) {
                            // Print the error.
                            print(error.toString());
                            // Pop the dialog.
                            Navigator.of(context).pop();
                            // Run the onError function.
                            widget.onError(error);
                          });
                        } else {
                          // Create aDocumentSnapshot that holds the absence document.
                          DocumentSnapshot ds = value.docs[0];
                          // Create a Map that holds the document's data.
                          Map<String, dynamic> absence = ds.data();
                          // Get the absences list.
                          List<dynamic> students = absence['absences'];
                          // Loop in the absences length.
                          for (int i = 0; i < widget.registration['absences'].length; i++) {
                            // Check if the student is already there.
                            if (containsStudents(students, widget.registration['absences'][i])) {
                              // Get the from time.
                              int from = getTime(widget.registration['fromTime']);
                              // Get the to time.
                              int to = getTime(widget.registration['toTime']);
                              // Get the range.
                              int range = to - from;
                              // Loop in the range.
                              for (int j = 0; j < range; j++) {
                                // Get the list of the given time.
                                List timeArray = getTimeArray(absence, fields[j + from - 8]);
                                // Check if the timeArray doesn't contain the student.
                                if (!timeArray.contains(widget.registration['absences'][i])) {
                                  // Add the student to the timeArray.
                                  timeArray.add(widget.registration['absences'][i]);
                                  // Set the array.
                                  absence = setTimeArray(absence, timeArray, fields[j + from - 8]);
                                }
                              }
                            } else {
                              // Add the student.
                              students.add(new Student(
                                      widget.registration['absences'][i],
                                      studentIndex(widget.cls, widget.registration['group'],
                                          widget.registration['absences'][i]),
                                      widget.registration['className'])
                                  .toMap());
                              // Get the from time.
                              int from = getTime(widget.registration['fromTime']);
                              // Get the to time.
                              int to = getTime(widget.registration['toTime']);
                              // Get the range.
                              int range = to - from;
                              // Loop in the range.
                              for (int j = 0; j < range; j++) {
                                // Get the list of the given time.
                                List timeArray = getTimeArray(absence, fields[j + from - 8]);
                                // Check if the timeArray doesn't contain the student.
                                if (!timeArray.contains(widget.registration['absences'][i])) {
                                  // Add the student to the timeArray.
                                  timeArray.add(widget.registration['absences'][i]);
                                  // Set the array.
                                  absence = setTimeArray(absence, timeArray, fields[j + from - 8]);
                                }
                              }
                            }
                          }
                          // Update the absences.
                          absence.update('absences', (value) => students);
                          // Add the absence object to the database.
                          FirebaseFirestore.instance
                              .collection('absences')
                              .doc(ds.id)
                              .set(absence)
                              .then((value) {
                            // Print a message.
                            print('Upload done with success!');
                            // Pop the dialog.
                            Navigator.of(context).pop();
                            // Run the onSuccess function.
                            widget.onSuccess();
                          }, onError: (error) {
                            // Print the error.
                            print(error.toString());
                            // Pop the dialog.
                            Navigator.of(context).pop();
                            // Run the onError function.
                            widget.onError(error);
                          });
                        }
                      }, onError: (error) {
                        // Print the error.
                        print(error.toString());
                        // Pop the dialog.
                        Navigator.of(context).pop();
                        // Run the onError function.
                        widget.onError(error);
                      });
                    }, onError: (error) {
                      // Print the error.
                      print(error.toString());
                      // Pop the dialog.
                      Navigator.of(context).pop();
                      // Run the onError function.
                      widget.onError(error);
                    });
                  }, onError: (error) {
                    // Print the error.
                    print(error.toString());
                    // Pop the dialog.
                    Navigator.of(context).pop();
                    // Run the onError function.
                    widget.onError(error);
                  });
                },
          child: Text('SAVE'),
        ),
      ],
    );
  }

  bool containsStudents(List<dynamic> students, String name) {
    for (int i = 0; i < students.length; i++) {
      dynamic student = students[i];
      if (student['name'] == name) {
        return true;
      }
    }
    return false;
  }

  int getTime(String time) {
    List<String> parts = time.split(":");
    print(parts[0]);
    return int.parse(parts[0]);
  }

  List getTimeArray(Map absence, String field) {
    switch (field) {
      case "f8t9":
        return absence['f8t9'];
      case "f9t10":
        return absence['f9t10'];
      case "f10t11":
        return absence['f10t11'];
      case "f11t12":
        return absence['f11t12'];
      case "f12t13":
        return absence['f12t13'];
      case "f13t14":
        return absence['f13t14'];
      case "f14t15":
        return absence['f14t15'];
      case "f15t16":
        return absence['f15t16'];
      case "f16t17":
        return absence['f16t17'];
      case "f17t18":
        return absence['f17t18'];
    }
    return null;
  }

  Map<String, dynamic> setTimeArray(Map<String, dynamic> absence, List timeArray, String field) {
    switch (field) {
      case "f8t9":
        absence.update('f8t9', (value) => timeArray);
        break;
      case "f9t10":
        absence.update('f9t10', (value) => timeArray);
        break;
      case "f10t11":
        absence.update('f10t11', (value) => timeArray);
        break;
      case "f11t12":
        absence.update('f11t12', (value) => timeArray);
        break;
      case "f12t13":
        absence.update('f12t13', (value) => timeArray);
        break;
      case "f13t14":
        absence.update('f13t14', (value) => timeArray);
        break;
      case "f14t15":
        absence.update('f14t15', (value) => timeArray);
        break;
      case "f15t16":
        absence.update('f15t16', (value) => timeArray);
        break;
      case "f16t17":
        absence.update('f16t17', (value) => timeArray);
        break;
      case "f17t18":
        absence.update('f17t18', (value) => timeArray);
        break;
    }
    return absence;
  }

  String studentIndex(Class mClass, String group, String name) {
    if (group == "Group 1") {
      return '${mClass.students1.indexOf(name) + 1}';
    } else {
      return '${mClass.students2.indexOf(name) + mClass.students1.length + 1}';
    }
  }
}

class GettingDataText extends StatelessWidget {
  final String _text;

  GettingDataText(this._text);

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: Theme.of(context).textTheme.bodyText1.copyWith(letterSpacing: 1),
    );
  }
}

class NoGlowScrollBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
