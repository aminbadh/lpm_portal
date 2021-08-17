import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class NameDialog extends StatefulWidget {
  final Function onDone;
  final Function(FirebaseException) onError;

  const NameDialog({Key key, this.onDone, this.onError}) : super(key: key);

  @override
  _NameDialogState createState() => _NameDialogState();
}

class _NameDialogState extends State<NameDialog> {
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _lastController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return AlertDialog(
      title: Text(
        'Edit Display Name',
        style: Theme.of(context).textTheme.headline6,
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              keyboardType: TextInputType.name,
              controller: _firstController,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: Constants.inputDecoration('First Name', themeChange),
              validator: (val) => val.isEmpty ? 'Please enter your name' : null,
            ),
            SizedBox(height: 12),
            TextFormField(
              keyboardType: TextInputType.name,
              controller: _lastController,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: Constants.inputDecoration('Last Name', themeChange),
              validator: (val) => val.isEmpty ? 'Please enter your name' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: Constants.primaryAccL,
                ),
          ),
        ),
        ElevatedButton(
          onPressed: _isLoading
              ? null
              : () {
                  if (_formKey.currentState.validate()) {
                    setState(() => _isLoading = true);
                    FirebaseFirestore.instance.collection('requests').add(
                      {
                        'id': FirebaseAuth.instance.currentUser.uid,
                        'firstName': _firstController.text,
                        'lastName': _lastController.text,
                      },
                    ).then(
                      (value) {
                        Navigator.of(context).pop();
                        widget.onDone();
                      },
                      onError: (error) {
                        Navigator.of(context).pop();
                        widget.onError(error);
                      },
                    );
                  }
                },
          child: Text(
            'Send Request',
            style: GoogleFonts.ibmPlexSerif(),
          ),
          style: ElevatedButton.styleFrom(
            primary: themeChange.darkTheme ? Constants.primaryAccD : Constants.primaryAccL,
            onPrimary:
                themeChange.darkTheme ? Constants.defaultTextColorL : Constants.defaultTextColorD,
          ),
        ),
      ],
    );
  }
}
