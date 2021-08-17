import 'package:flutter/material.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/native/android/widgets/text_button_s.dart';
import 'package:lpm/native/android/widgets/widgets.dart';
import 'package:lpm/native/utils/auth.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:lpm/utils/strings.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  final Function onSignIn;

  const SignUpScreen({Key key, @required this.onSignIn}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DarkThemeProvider themeChange;
  bool _isLoading = false;

  Widget e2(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: Constants.inputDecoration(Strings.email, themeChange),
                  validator: (val) => val.isEmpty ? Strings.pleaseEnterEmail : null,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _passController,
                  obscureText: true,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: Constants.inputDecoration(Strings.password, themeChange),
                  validator: (val) => val.length < 6 ? Strings.pleaseEnterPass : null,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _codeController,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: Constants.inputDecoration(Strings.verCode, themeChange),
                  validator: (val) => val.length < 12 ? Strings.pleaseEnterCode : null,
                ),
                SizedBox(height: 16.0),
                ButtonBar(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: themeChange.darkTheme ? Constants.primaryAccL : Constants.primaryD,
                      ),
                      onPressed: _isLoading
                          ? null
                          : () {
                              if (_formKey.currentState.validate()) {
                                WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                setState(() => _isLoading = true);
                                Auth.studentUp(
                                  _emailController.text,
                                  _passController.text,
                                  _codeController.text,
                                  (error) {
                                    setState(() => _isLoading = false);
                                    print(error.toString());
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content: Text(
                                          error.message,
                                          style: TextStyle(
                                              color: themeChange.darkTheme
                                                  ? Constants.textColorSnackBarD
                                                  : Constants.textColorSnackBarL),
                                        ),
                                        duration: Duration(minutes: 1),
                                      ),
                                    );
                                  },
                                  () {
                                    setState(() => _isLoading = false);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content: Text(
                                          Strings.verNotFound,
                                          style: TextStyle(
                                              color: themeChange.darkTheme
                                                  ? Constants.textColorSnackBarD
                                                  : Constants.textColorSnackBarL),
                                        ),
                                        duration: Duration(minutes: 1),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
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
                              Strings.signUp,
                              style: Theme.of(context).textTheme.bodyText1.copyWith(
                                    color: themeChange.darkTheme
                                        ? Constants.defaultTextColorD
                                        : Constants.defaultTextColorL,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget e3(context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Strings.alreadyAccount,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 8),
          TextButtonS(onSignUp: widget.onSignIn, text: Strings.signIn),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    themeChange = Provider.of<DarkThemeProvider>(context);
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxHeight > 600) {
        return Column(
          children: [
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment(0, 0.5),
                child: Title1(text: Strings.signUp),
              ),
            ),
            Expanded(
              flex: 4,
              child: Center(
                child: e2(context),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: e3(context),
              ),
            ),
          ],
        );
      } else {
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Title1(text: Strings.signUp)],
              ),
              SizedBox(height: 64),
              e2(context),
              SizedBox(height: 36),
              e3(context),
              SizedBox(height: 12),
            ],
          ),
        );
      }
    });
  }
}
