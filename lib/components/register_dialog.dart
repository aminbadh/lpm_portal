import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterDialog extends StatefulWidget {
  final Function onLoggedIn;

  RegisterDialog(this.onLoggedIn);

  @override
  _RegisterDialogState createState() => _RegisterDialogState();
}

class _RegisterDialogState extends State<RegisterDialog> {
  // Create two TextEditingControllers.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _verCodeController = TextEditingController();

  // Create a globalKey for the form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Create a bool that holds the loading state (false as default).
  bool _isLoading = false;

  // Create used objects.
  String _error;
  bool _remember = false;

  // Create instance of the auth service.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create used strings.
  final String _email = 'Email';
  final String _emailValidation = 'Please enter an email';
  final String _password = 'Password';
  final String _passwordValidation = 'Please enter a valid password';
  final String _verCode = 'Verification Code';
  final String _verCodeValidation = 'Please enter a valid code';
  final String _createAccount = 'Create an account';
  final String _create = 'Create';

  // Used when the user press on the login button.
  void onSignUp(BuildContext context) async {
    // Validate the form.
    if (_formKey.currentState.validate()) {
      // Get focus.
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      // Update the loading state to true and the error message to null.
      setState(() {
        _isLoading = true;
        _error = null;
      });
      FirebaseFirestore.instance
          .collection('codes')
          .where('code', isEqualTo: _verCodeController.text)
          .get()
          .then((val) {
        if (val.docs.isEmpty) {
          print('YEAH OH YEAH CREEPER');
        } else {
          DocumentSnapshot doc = val.docs.first;
          Map<String, String> data = {
            'firstName': doc.get('firstName'),
            'lastName': doc.get('lastName'),
            'role': doc.get('role'),
            'mClass': doc.get('mClass'),
          };
          // Try to sign up the user.
          try {
            // Sign up the user with the given data.
            _auth
                .createUserWithEmailAndPassword(
                    email: _emailController.text, password: _passwordController.text)
                .then((value) async {
              if (value.user != null) {
                if (_remember) {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  List<String> emails = prefs.getStringList('emails') ?? [];
                  List<String> passes = prefs.getStringList('passwords') ?? [];
                  if (!emails.contains(_emailController.text))
                    emails.insert(0, _emailController.text);
                  if (!passes.contains(_passwordController.text))
                    passes.insert(0, _passwordController.text);
                  prefs.setStringList('emails', emails);
                  prefs.setStringList('passwords', passes);
                }
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(value.user.uid)
                    .set(data)
                    .then((value) {
                  setState(() => _isLoading = false);
                  Navigator.of(context).pop();
                  widget.onLoggedIn();
                }).onError((error, stackTrace) {
                  // Print the exception.
                  print(error.toString());
                  // Update the error message and the loading state to false.
                  setState(() {
                    _error = error.message;
                    _isLoading = false;
                  });
                });
              }
            });
          } on FirebaseAuthException catch (exception) {
            // Print the exception.
            print(exception.toString());
            // Update the error message and the loading state to false.
            setState(() {
              _error = exception.message;
              _isLoading = false;
            });
          }
        }
      }).onError((error, stackTrace) {
        // Print the exception.
        print(error.toString());
        // Update the error message and the loading state to false.
        setState(() {
          _error = error.message;
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _createAccount,
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(height: 12.0),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                        style: Theme.of(context).textTheme.bodyText1,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        decoration: InputDecoration(labelText: _email),
                      ),
                      validator: (val) => val.isEmpty ? _emailValidation : null,
                      onSuggestionSelected: (suggestion) async {
                        _emailController.text = suggestion;
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        _passwordController.text = prefs
                            .getStringList('passwords')
                            .elementAt(prefs.getStringList('emails').indexOf(suggestion));
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(
                            suggestion,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              List<String> emails = prefs.getStringList('emails') ?? [];
                              List<String> passwords = prefs.getStringList('passwords') ?? [];
                              int index = emails.indexOf(suggestion);
                              emails.removeAt(index);
                              passwords.removeAt(index);
                              prefs.setStringList('emails', emails);
                              prefs.setStringList('passwords', passwords);
                              WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                            },
                            splashRadius: 20,
                          ),
                        );
                      },
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      suggestionsCallback: (String pattern) async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        List<String> allEmails = prefs.getStringList('emails') ?? [];
                        List<String> emails =
                            allEmails.where((element) => element.contains(pattern)).toList();
                        return emails.isEmpty ? null : emails;
                      },
                    ),
                    SizedBox(height: 8.0),
                    TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                        style: Theme.of(context).textTheme.bodyText1,
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(labelText: _password),
                      ),
                      validator: (val) => val.length < 6 ? _passwordValidation : null,
                      onSuggestionSelected: (suggestion) async {
                        _emailController.text = suggestion;
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        _passwordController.text = prefs
                            .getStringList('passwords')
                            .elementAt(prefs.getStringList('emails').indexOf(suggestion));
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(
                            suggestion,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        );
                      },
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      suggestionsCallback: (String pattern) async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        List<String> allEmails = prefs.getStringList('emails') ?? [];
                        List<String> emails =
                            allEmails.where((element) => element.contains(pattern)).toList();
                        return emails.isEmpty ? null : emails;
                      },
                    ),
                    SizedBox(height: 8.0),
                    TextFormField(
                      style: Theme.of(context).textTheme.bodyText1,
                      controller: _verCodeController,
                      decoration: InputDecoration(labelText: _verCode),
                      validator: (val) => val.length == 12 ? null : _verCodeValidation,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.0),
              CheckboxListTile(
                title: Text(
                  'Remember',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                value: _remember,
                onChanged: (value) => setState(() => _remember = value),
                activeColor: themeChange.darkTheme ? Constants.primaryAccD : Constants.primaryAccL,
              ),
              SizedBox(height: 12.0),
              Row(
                children: [
                  Expanded(
                      child: _error == null
                          ? Container()
                          : Text(
                              _error,
                              style: GoogleFonts.ibmPlexSerif().copyWith(
                                fontSize: 12.0,
                                color: Colors.red[700],
                              ),
                            )),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: themeChange.darkTheme ? Constants.primaryD : Constants.primaryL,
                      onPrimary: themeChange.darkTheme
                          ? Constants.defaultTextColorL
                          : Constants.defaultTextColorD,
                    ),
                    onPressed: _isLoading ? null : () => onSignUp(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 12.0,
                      ),
                      child: Row(
                        children: [
                          _isLoading
                              ? Row(
                                  children: [
                                    Container(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        strokeWidth: 1,
                                      ),
                                      width: 16,
                                      height: 16,
                                    ),
                                    SizedBox(width: 12),
                                  ],
                                )
                              : Container(),
                          Text(
                            _create,
                            style: GoogleFonts.ibmPlexSerif(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
