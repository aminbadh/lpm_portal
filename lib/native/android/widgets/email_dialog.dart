import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class EmailDialog extends StatefulWidget {
  final Function onDone;
  final Function(FirebaseAuthException) onError;

  const EmailDialog({Key key, this.onDone, this.onError}) : super(key: key);

  @override
  _EmailDialogState createState() => _EmailDialogState();
}

class _EmailDialogState extends State<EmailDialog> {
  final TextEditingController _emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return AlertDialog(
      title: Text(
        'Change Email',
        style: Theme.of(context).textTheme.headline6,
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: Constants.inputDecoration('New Email', themeChange),
              validator: (val) => val.isEmpty
                  ? 'Please enter an email address'
                  : val == FirebaseAuth.instance.currentUser.email
                      ? 'You\'re already using this email address'
                      : null,
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
                    FirebaseAuth.instance.currentUser.updateEmail(_emailController.text).then(
                        (value) {
                      setState(() => _isLoading = false);
                      Navigator.of(context).pop();
                      widget.onDone();
                    }, onError: (error) {
                      Navigator.of(context).pop();
                      widget.onError(error);
                    });
                  }
                },
          child: Text(
            'Update',
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
