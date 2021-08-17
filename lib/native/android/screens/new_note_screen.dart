import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/native/android/models/class.dart';
import 'package:lpm/native/android/models/student_note.dart';
import 'package:lpm/native/android/screens/note_preview_screen.dart';
import 'package:lpm/native/android/screens/select_class_screen.dart';
import 'package:lpm/screens/tools/attendance_register/new_registration.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class NewNoteScreen extends StatefulWidget {
  final Function onSaved;
  final Function(FirebaseException) onError;
  final QuerySnapshot notes;

  const NewNoteScreen({Key key, this.onSaved, this.onError, this.notes}) : super(key: key);

  @override
  _NewNoteScreenState createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {
  final TextEditingController _classController = TextEditingController();
  final _editingKey = GlobalKey();
  DarkThemeProvider themeChange;
  Class _selectedClass;
  Widget _selectClass;
  List<StudentNote> notes;
  bool isNew = true;

  @override
  void initState() {
    super.initState();
    _selectClass =
        SelectClassScreen(onSelected: (mClass) => setState(() => _selectedClass = mClass));
  }

  @override
  Widget build(BuildContext context) {
    themeChange = Provider.of<DarkThemeProvider>(context);

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
          onPressed: () => _selectedClass == null
              ? Navigator.of(context).pop()
              : setState(() => _selectedClass = null),
        ),
        actions: _selectedClass == null
            ? []
            : [
                IconButton(
                  onPressed: () => isNew ? _save() : _saveOld(),
                  icon: Icon(Icons.save),
                  tooltip: 'Save',
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
        _selectedClass == null ? SizedBox() : _body(),
      ],
    );
  }

  Widget _noteBody(Class selectedClass) {
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
              _students(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _students() {
    List<dynamic> students = _selectedClass.students ?? [];
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
                        controller: notes[index].controller,
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

  void _save() {
    Map<String, dynamic> data = {};
    data.putIfAbsent('mClass', () => _selectedClass.data['full']);
    data.putIfAbsent('classPath', () => _selectedClass.docRef);
    if (_classController.text.isNotEmpty) {
      data.putIfAbsent('note', () => _classController.text);
    }
    Map<String, dynamic> students = {};
    notes.forEach((element) {
      if (element.controller.text.isNotEmpty) {
        students.putIfAbsent(element.student, () => element.controller.text);
      }
    });
    data.putIfAbsent('students', () => students);
    Navigator.of(context).pop();
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('notes')
        .add(data)
        .then((value) => widget.onSaved(), onError: (error) => widget.onError(error));
  }

  Widget _body() {
    for (DocumentSnapshot doc in widget.notes.docs) {
      if (_selectedClass.data['full'] == doc.get('mClass')) {
        setState(() => isNew = false);
        return NoteEditorContent(
            key: _editingKey, note: doc, onSaved: widget.onSaved, onError: widget.onError);
      }
    }
    return _noteBody(_selectedClass);
  }

  void _saveOld() {
    final dynamic state = _editingKey.currentState;
    state.save();
  }
}
