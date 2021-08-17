import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class ChangeNameDialog extends StatefulWidget {
  final Function onDone;

  ChangeNameDialog(this.onDone);

  @override
  _ChangeNameDialogState createState() => _ChangeNameDialogState();
}

class _ChangeNameDialogState extends State<ChangeNameDialog> {
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _lastController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _error;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Change Display Name',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 8.0),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.name,
                        controller: _firstController,
                        style: Theme.of(context).textTheme.bodyText1,
                        decoration: InputDecoration(labelText: 'First Name'),
                        validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                      ),
                      SizedBox(height: 8.0),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        controller: _lastController,
                        style: Theme.of(context).textTheme.bodyText1,
                        decoration: InputDecoration(labelText: 'Last Name'),
                        validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                      ),
                    ],
                  )),
              SizedBox(height: 24.0),
              Row(
                children: [
                  Expanded(
                    child: _error == null
                        ? _isLoading
                            ? Center(
                                child: Container(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : Container()
                        : Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              _error,
                              style: Theme.of(context).textTheme.bodyText2.copyWith(
                                    color: Colors.red[700],
                                    fontSize: 12.0,
                                  ),
                            ),
                          ),
                  ),
                  SizedBox(width: 8),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Cancel',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Constants.primaryAccL,
                              ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          setState(() => _error = null);
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
                                setState(() => _isLoading = false);
                                Navigator.of(context).pop();
                                widget.onDone();
                              },
                              onError: (error) => setState(
                                () {
                                  print(error.toString());
                                  _error = error.message;
                                  _isLoading = false;
                                },
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Send Request',
                          style: GoogleFonts.ibmPlexSerif(),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: themeChange.darkTheme ? Constants.primaryD : Constants.primaryL,
                          onPrimary: themeChange.darkTheme
                              ? Constants.defaultTextColorL
                              : Constants.defaultTextColorD,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
