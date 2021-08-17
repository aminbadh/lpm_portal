import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/models/student.dart';
import 'package:lpm/native/android/models/class.dart';
import 'package:lpm/native/android/screens/select_class_screen.dart';
import 'package:lpm/native/utils/utils.dart';
import 'package:lpm/screens/tools/attendance_register/new_registration.dart';
import 'package:lpm/shared/data.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class AttendanceRegisterScreen extends StatefulWidget {
  final Class selectedClass;

  const AttendanceRegisterScreen({Key key, this.selectedClass}) : super(key: key);
  @override
  _AttendanceRegisterScreenState createState() => _AttendanceRegisterScreenState();
}

class _AttendanceRegisterScreenState extends State<AttendanceRegisterScreen> {
  Class _selectedClass;
  DarkThemeProvider themeChange;
  bool _isLoading = false;
  String _fromTime = '${DateTime.now().hour}:0';
  String _toTime = '${DateTime.now().hour + 1}:0';
  List _absences = [];
  DocumentSnapshot _userDoc;
  Widget _selectClass;

  @override
  void initState() {
    super.initState();
    _selectClass =
        SelectClassScreen(onSelected: (mClass) => setState(() => _selectedClass = mClass));
    _selectedClass = widget.selectedClass;
  }

  @override
  Widget build(BuildContext context) {
    themeChange = Provider.of<DarkThemeProvider>(context);
    _userDoc = GlobalData.instance.get('UserDoc');

    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).scaffoldBackgroundColor,
          statusBarIconBrightness: themeChange.darkTheme ? Brightness.light : Brightness.dark,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          _selectedClass == null ? 'Select A Class' : _selectedClass.data['full'],
          style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 18),
        ),
        elevation: 0,
        iconTheme: IconThemeData(
          color: themeChange.darkTheme ? Constants.defaultTextColorD : Constants.defaultTextColorL,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          splashRadius: 24,
          onPressed: () => widget.selectedClass == null
              ? _selectedClass == null
                  ? Navigator.of(context).pop()
                  : setState(() => _selectedClass = null)
              : Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 1,
            color: themeChange.darkTheme ? Constants.dividerColorD : Constants.dividerColorL,
          ),
          Expanded(
            child: _stack(),
          ),
        ],
      ),
    );
  }

  Widget _stack() {
    return Stack(
      children: [
        _selectClass,
        _selectedClass == null ? SizedBox() : _registerBody(_selectedClass),
      ],
    );
  }

  Widget _registerBody(Class cls) {
    List<dynamic> students = cls.students ?? [];
    students.sort((a, b) => a.compareTo(b));
    List<dynamic> classAbsences = cls.absences ?? [];
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Theme(
        data: ThemeData(
          accentColor: themeChange.darkTheme ? Constants.primaryAccD : Constants.primaryAccL,
          dividerColor: themeChange.darkTheme ? Constants.dividerColorD : Constants.dividerColorL,
        ),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Time',
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
                                  'From',
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
                                  'To',
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
            Divider(
              indent: 4,
              endIndent: 4,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Students',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: themeChange.darkTheme ? Constants.greyD : Constants.greyL,
                          fontSize: 18.0,
                        ),
                  ),
                  SizedBox(height: 4.0),
                  ScrollConfiguration(
                    behavior: NoGlowScrollBehaviour(),
                    child: ListView.builder(
                      itemCount: students.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _stTile(
                            students[index], classAbsences, index == students.length - 1);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).accentColor,
                ),
                child: _isLoading
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[50]),
                            ),
                          ),
                          SizedBox(width: 12.0),
                          Text(
                            'SAVE',
                            style: Theme.of(context).textTheme.bodyText1.copyWith(
                                  color: Colors.grey[50],
                                  letterSpacing: 2,
                                ),
                          ),
                        ],
                      )
                    : Text(
                        'SAVE',
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Colors.grey[50],
                              letterSpacing: 2,
                            ),
                      ),
                onPressed: _isLoading
                    ? null
                    : () {
                        Map<String, dynamic> registration = {
                          'professorName':
                              '${_userDoc['name']['first']} ${_userDoc['name']['last']}',
                          'professorId': _userDoc.id,
                          'subject': _userDoc['subject'],
                          'fromTime': _fromTime,
                          'toTime': _toTime,
                          'className': cls.data['full'],
                          'absences': _absences,
                          'submitTime': DateTime.now().millisecondsSinceEpoch,
                        };
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
                                    absence =
                                        setTimeArray(absence, timeArray, fields[j + from - 8]);
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
              ),
            ),
            SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  Widget _stTile(name, List absences, bool isLast) => Column(
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
                ),
        ],
      );

  String studentIndex(Class mClass, String group, String name) =>
      '${mClass.students.indexOf(name) + 1}';

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

  void onSuccess() {
    Navigator.of(context).pop();
  }

  void onError(error) {
    Utils.showSnackBar(context, error.message, themeChange);
  }

  TextStyle _studentTextStyle(name) => _absences.contains(name)
      ? TextStyle(decoration: TextDecoration.lineThrough, fontSize: 18.0)
      : TextStyle(fontSize: 18.0);
}
