import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class ChangeEmailDialog extends StatefulWidget {
  final Function onLoggedIn;

  ChangeEmailDialog(this.onLoggedIn);

  @override
  _ChangeEmailDialogState createState() => _ChangeEmailDialogState();
}

class _ChangeEmailDialogState extends State<ChangeEmailDialog> {
  final TextEditingController _emailController = TextEditingController();

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
                'Change Email Address',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 8.0),
              Form(
                key: _formKey,
                child: TextFormField(
                  style: Theme.of(context).textTheme.bodyText1,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'New Email'),
                  validator: (val) => val.isEmpty
                      ? 'Please enter an email address'
                      : val == FirebaseAuth.instance.currentUser.email
                          ? 'You\'re already using this email address'
                          : null,
                ),
              ),
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
                            FirebaseAuth.instance.currentUser
                                .updateEmail(_emailController.text)
                                .then((value) {
                              setState(() => _isLoading = false);
                              Navigator.of(context).pop();
                              widget.onLoggedIn();
                            },
                                    onError: (error) => setState(
                                          () {
                                            print(error.toString());
                                            _error = error.message;
                                            _isLoading = false;
                                          },
                                        ));
                          }
                        },
                        child: Text(
                          'Update',
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
