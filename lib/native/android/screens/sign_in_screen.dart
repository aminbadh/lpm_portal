import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/native/android/widgets/text_button_s.dart';
import 'package:lpm/native/android/widgets/widgets.dart';
import 'package:lpm/native/utils/auth.dart';
import 'package:lpm/native/utils/utils.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:lpm/utils/strings.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  final Function onSignUp;

  const SignInScreen({Key key, @required this.onSignUp}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
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
                ButtonBar(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: themeChange.darkTheme ? Constants.primaryAccL : Constants.primaryD,
                      ),
                      onLongPress: _isLoading
                          ? null
                          : () async {
                              String uuid;
                              final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
                              try {
                                var build = await deviceInfoPlugin.androidInfo;
                                uuid = build.androidId;
                              } on PlatformException {
                                print('Failed to get platform version');
                              }
                              Clipboard.setData(ClipboardData(text: uuid));
                            },
                      onPressed: _isLoading
                          ? null
                          : () {
                              if (_formKey.currentState.validate()) {
                                WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                setState(() => _isLoading = true);
                                Auth.studentIn(
                                  _emailController.text,
                                  _passController.text,
                                  (error) {
                                    setState(() => _isLoading = false);
                                    print(error.toString());
                                    Utils.showSnackBar(
                                      context,
                                      error.message,
                                      themeChange,
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
                              Strings.signIn,
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
            Strings.noAccountYet,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 8),
          TextButtonS(onSignUp: widget.onSignUp, text: Strings.signUp),
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
                child: Title1(text: Strings.signIn),
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
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Title1(text: Strings.signIn)],
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
