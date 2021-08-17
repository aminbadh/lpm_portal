import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/native/android/screens/new_note_screen.dart';
import 'package:lpm/native/android/screens/note_preview_screen.dart';
import 'package:lpm/native/utils/utils.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final _scaffoldKey = GlobalKey();
  QuerySnapshot notes;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        tooltip: 'Add',
        child: Icon(
          Icons.add,
          color: Constants.defaultTextColorL,
        ),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NewNoteScreen(
            onSaved: () => Utils.showSnackBar(_scaffoldKey.currentContext, 'Saved', themeChange),
            onError: (error) =>
                Utils.showSnackBar(_scaffoldKey.currentContext, error.message, themeChange),
            notes: notes,
          ),
        )),
      ),
      body: Theme(
        data: ThemeData(
          accentColor: themeChange.darkTheme ? Constants.primaryAccD : Constants.primaryAccL,
          dividerColor: themeChange.darkTheme ? Constants.dividerColorD : Constants.dividerColorL,
          textTheme: Theme.of(context).textTheme,
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser.uid)
              .collection('notes')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              notes = snapshot.data;
              return ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) => NoteCard(
                  note: snapshot.data.docs[index],
                  scaffoldKey: _scaffoldKey,
                ),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              final dynamic error = snapshot.error;
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    error.message,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              );
            } else {
              return Center(
                  child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                    themeChange.darkTheme ? Constants.primaryAccD : Constants.primaryAccL),
              ));
            }
          },
        ),
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  final DocumentSnapshot note;
  final GlobalKey scaffoldKey;

  const NoteCard({Key key, this.note, this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.5),
          width: 1,
        ),
      ),
      elevation: 0.0,
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NotePreviewScreen(
            note: note,
            onSaved: () => Utils.showSnackBar(scaffoldKey.currentContext, 'Saved', themeChange),
            onError: (error) =>
                Utils.showSnackBar(scaffoldKey.currentContext, error.message, themeChange),
          ),
        )),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                note.get('mClass'),
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Divider(
              indent: 20,
              endIndent: 20,
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _content(),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15),
              ),
            )
          ],
        ),
      ),
    );
  }

  String _content() {
    try {
      String data = note.get('note');
      if (data.isNotEmpty) {
        return data;
      } else {
        throw Exception();
      }
    } catch (e) {
      Map<String, dynamic> students = note.get('students');
      if (students.isEmpty) {
        return 'Empty Note';
      } else {
        return 'Students Note';
      }
    }
  }
}
