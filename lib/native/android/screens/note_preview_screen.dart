import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/native/android/models/student_note.dart';
import 'package:lpm/native/android/widgets/widgets.dart';
import 'package:lpm/screens/tools/attendance_register/new_registration.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class NotePreviewScreen extends StatefulWidget {
  final DocumentSnapshot note;
  final Function onSaved;
  final Function(FirebaseException) onError;

  const NotePreviewScreen({Key key, @required this.note, this.onSaved, this.onError})
      : super(key: key);

  @override
  _NotePreviewScreenState createState() => _NotePreviewScreenState();
}

class _NotePreviewScreenState extends State<NotePreviewScreen> {
  final _noteKey = GlobalKey();
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).scaffoldBackgroundColor,
          statusBarIconBrightness: themeChange.darkTheme ? Brightness.light : Brightness.dark,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          widget.note['mClass'],
          style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 18),
        ),
        elevation: 0,
        iconTheme: IconThemeData(
          color: themeChange.darkTheme ? Constants.defaultTextColorD : Constants.defaultTextColorL,
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            splashRadius: 24,
            onPressed: () => Navigator.of(context).pop()),
        actions: _isEditing
            ? [
                IconButton(
                  onPressed: () => setState(() => _isEditing = false),
                  icon: Icon(Icons.clear),
                  tooltip: 'Cancel',
                  splashRadius: 24,
                ),
                IconButton(
                  onPressed: () {
                    final dynamic state = _noteKey.currentState;
                    state.save();
                  },
                  icon: Icon(Icons.done),
                  tooltip: 'Save',
                  splashRadius: 24,
                ),
                SizedBox(width: 4),
              ]
            : [
                IconButton(
                  onPressed: () => setState(() => _isEditing = true),
                  icon: Icon(Icons.edit_outlined),
                  tooltip: 'Edit',
                  splashRadius: 24,
                ),
                SizedBox(width: 4),
              ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 1,
            color: themeChange.darkTheme ? Constants.dividerColorD : Constants.dividerColorL,
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: _isEditing
                  ? NoteEditorContent(
                      key: _noteKey,
                      note: widget.note,
                      onSaved: widget.onSaved,
                      onError: widget.onError)
                  : NotePreviewContent(note: widget.note),
            ),
          ),
        ],
      ),
    );
  }
}

class NotePreviewContent extends StatelessWidget {
  final DocumentSnapshot note;

  const NotePreviewContent({Key key, this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Theme(
      data: ThemeData(
        accentColor: themeChange.darkTheme ? Constants.primaryAccD : Constants.primaryAccL,
        dividerColor: themeChange.darkTheme ? Constants.dividerColorD : Constants.dividerColorL,
        textTheme: Theme.of(context).textTheme,
      ),
      child: Scrollbar(
        child: ListView(
          children: [
            DrawerGroup(text: 'CLASS NOTE'),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: _classNote(context, themeChange),
            ),
            Divider(indent: 4, endIndent: 4, height: 1),
            DrawerGroup(text: 'STUDENTS NOTE'),
            _students(context, themeChange),
          ],
        ),
      ),
    );
  }

  Widget _classNote(BuildContext context, themeChange) {
    try {
      String data = note.get('note');
      if (data.isNotEmpty) {
        return Text(data, style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16));
      } else {
        throw Exception();
      }
    } catch (e) {
      return Text('EMPTY',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontSize: 16, color: themeChange.darkTheme ? Colors.grey[400] : Constants.greyL));
    }
  }

  Widget _students(BuildContext context, themeChange) {
    if (note.get('students').isNotEmpty) {
      return ScrollConfiguration(
        behavior: NoGlowScrollBehaviour(),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.all(4),
          itemCount: note.get('students').length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 2.0),
                    child: Column(
                      children: [
                        Text(
                          note.get('students').keys.toList()[index],
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 13),
                        ),
                        SizedBox(height: 6),
                        Text(
                          note.get('students').values.toList()[index],
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
                index == note.get('students').length - 1
                    ? Container()
                    : Divider(height: 3, endIndent: 8, indent: 8),
              ],
            );
          },
        ),
      );
    } else {
      return Text('EMPTY',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontSize: 16, color: themeChange.darkTheme ? Colors.grey[400] : Constants.greyL));
    }
  }
}

class NoteEditorContent extends StatefulWidget {
  final DocumentSnapshot note;
  final Function onSaved;
  final Function(FirebaseException) onError;

  const NoteEditorContent({Key key, this.note, this.onSaved, this.onError}) : super(key: key);

  @override
  _NoteEditorContentState createState() => _NoteEditorContentState();
}

class _NoteEditorContentState extends State<NoteEditorContent> {
  TextEditingController _classController;
  List<StudentNote> notes;

  @override
  void initState() {
    super.initState();
    _classController = TextEditingController(text: _note(widget.note));
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return FutureBuilder(
        future: FirebaseFirestore.instance.doc(widget.note.get('classPath')).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            return _noteBody(snapshot.data, context);
          } else {
            return Center(
                child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                  themeChange.darkTheme ? Constants.primaryAccD : Constants.primaryAccL),
            ));
          }
        });
  }

  Widget _noteBody(DocumentSnapshot classDoc, BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Theme(
        data: ThemeData(
          accentColor: themeChange.darkTheme ? Constants.primaryAccD : Constants.primaryAccL,
          dividerColor: themeChange.darkTheme ? Constants.dividerColorD : Constants.dividerColorL,
          textTheme: Theme.of(context).textTheme,
        ),
        child: Scrollbar(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: TextField(
                  keyboardType: TextInputType.text,
                  controller: _classController,
                  maxLines: 5,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: Constants.inputDecoration('Class Note', themeChange),
                ),
              ),
              Divider(indent: 4, endIndent: 4, height: 1),
              _students(classDoc, context),
            ],
          ),
        ),
      ),
    );
  }

  String _note(note) {
    try {
      return note.get('note');
    } catch (e) {
      return '';
    }
  }

  Widget _students(DocumentSnapshot classDoc, BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    List<dynamic> students = classDoc.get('students') ?? [];
    students.sort((a, b) => a.compareTo(b));
    notes = students.map<StudentNote>((e) => StudentNote(e, TextEditingController())).toList();
    return ScrollConfiguration(
      behavior: NoGlowScrollBehaviour(),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(4),
        itemCount: students.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 2.0),
                  child: Column(
                    children: [
                      Text(
                        notes[index].student,
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      TextField(
                        keyboardType: TextInputType.text,
                        controller: _studentController(notes[index]),
                        style: Theme.of(context).textTheme.bodyText1,
                        decoration: Constants.inputDecoration('Note', themeChange),
                      ),
                    ],
                  ),
                ),
              ),
              index == students.length - 1
                  ? Container()
                  : Divider(height: 3, endIndent: 8, indent: 8),
            ],
          );
        },
      ),
    );
  }

  TextEditingController _studentController(StudentNote studentNote) {
    if (widget.note.get('students').keys.contains(studentNote.student)) {
      studentNote.controller.text = widget.note
          .get('students')
          .values
          .elementAt(widget.note.get('students').keys.toList().indexOf(studentNote.student));
      return studentNote.controller;
    } else {
      return studentNote.controller;
    }
  }

  void save() {
    Map<String, dynamic> data = widget.note.data();
    if (_classController.text != _note(widget.note)) {
      if (data.containsKey('note')) {
        data.update('note', (value) => _classController.text);
      } else {
        data.putIfAbsent('note', () => _classController.text);
      }
    }
    Map<String, dynamic> students = {};
    notes.forEach((element) {
      if (element.controller.text.isNotEmpty) {
        students.putIfAbsent(element.student, () => element.controller.text);
      }
    });
    data.update('students', (value) => students);
    Navigator.of(context).pop();
    FirebaseFirestore.instance
        .doc(widget.note.reference.path)
        .set(data)
        .then((value) => widget.onSaved(), onError: (error) => widget.onError(error));
  }
}
