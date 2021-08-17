import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/native/android/widgets/add_device_dialog.dart';
import 'package:lpm/native/android/widgets/email_dialog.dart';
import 'package:lpm/native/android/widgets/name_dialog.dart';
import 'package:lpm/native/android/widgets/outlined_card.dart';
import 'package:lpm/native/android/widgets/trusted_devices.dart';
import 'package:lpm/native/utils/utils.dart';
import 'package:lpm/shared/data.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class AccountScreenProf extends StatefulWidget {
  @override
  _AccountScreenProfState createState() => _AccountScreenProfState();
}

class _AccountScreenProfState extends State<AccountScreenProf> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Theme(
      data: ThemeData(
        accentColor: themeChange.darkTheme ? Constants.primaryAccD : Constants.primaryAccL,
        dividerColor: themeChange.darkTheme ? Constants.dividerColorD : Constants.dividerColorL,
        textTheme: Theme.of(context).textTheme,
      ),
      child: ListView(
        children: [
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(128),
                    child: Image.asset(
                      'assets/images/iii.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(width: 24),
                Expanded(
                  // TODO: Complete...
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      primary:
                          themeChange.darkTheme ? Constants.primaryAccD : Constants.primaryAccL,
                    ),
                    onPressed: () {},
                    icon: Icon(
                      Icons.edit,
                      size: 20,
                      color: themeChange.darkTheme ? Constants.primaryAccD : Constants.primaryAccL,
                    ),
                    label: Text(
                      'CHANGE PICTURE',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              children: [
                OutlinedCard(
                  title: 'YOUR NAME',
                  buttonLabel: 'Edit request',
                  onPressed: () => showDialog(
                      context: context,
                      builder: (_) => NameDialog(
                            onDone: () => Utils.showSnackBar(context, 'Request sent', themeChange),
                            onError: (error) =>
                                Utils.showSnackBar(context, error.message, themeChange),
                          )),
                  child: Text(
                    GlobalData.instance.get('UserDoc') == null
                        ? ''
                        : '${GlobalData.instance.get('UserDoc').get('name')['first']} '
                            '${GlobalData.instance.get('UserDoc').get('name')['last']}',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
                  ),
                ),
                OutlinedCard(
                    title: 'EMAIL',
                    buttonLabel: 'Change email',
                    onPressed: () => showDialog(
                        context: context,
                        builder: (_) => EmailDialog(
                              onDone: () {
                                setState(() {});
                                Utils.showSnackBar(context, 'Email Address Updated', themeChange);
                              },
                              onError: (error) =>
                                  Utils.showSnackBar(context, error.message, themeChange),
                            )),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            FirebaseAuth.instance.currentUser.email,
                            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
                          ),
                        ),
                        FirebaseAuth.instance.currentUser.emailVerified
                            ? SizedBox()
                            : InkWell(
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: Text(
                                      'Verify Your Email',
                                      style: Theme.of(context).textTheme.headline6,
                                    ),
                                    content: Text(
                                      'You need to verify your email address to '
                                      'access all the tools.',
                                      style: Theme.of(context).textTheme.bodyText1,
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          FirebaseAuth.instance.currentUser
                                              .sendEmailVerification()
                                              .then((value) {
                                            Utils.showSnackBar(
                                                context, 'Verification Email Sent', themeChange);
                                          }, onError: (error) {
                                            Utils.showSnackBar(context, error.message, themeChange);
                                          });
                                        },
                                        child: Text(
                                          'Send verification email',
                                          style: GoogleFonts.ibmPlexSerif(),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: themeChange.darkTheme
                                              ? Constants.primaryAccD
                                              : Constants.primaryAccL,
                                          onPrimary: themeChange.darkTheme
                                              ? Constants.defaultTextColorL
                                              : Constants.defaultTextColorD,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Icon(
                                    Icons.warning,
                                    color:
                                        themeChange.darkTheme ? Colors.red[500] : Colors.red[700],
                                  ),
                                ),
                              ),
                      ],
                    )),
                OutlinedCard(
                  title: 'PASSWORD',
                  buttonLabel:
                      FirebaseAuth.instance.currentUser.emailVerified ? 'Change password' : '',
                  onPressed: () => FirebaseAuth.instance
                      .sendPasswordResetEmail(email: FirebaseAuth.instance.currentUser.email)
                      .then(
                          (value) => Utils.showSnackBar(
                              context,
                              'Password Reset Email is Sent To Your Current Email Address',
                              themeChange),
                          onError: (error) =>
                              Utils.showSnackBar(context, error.message, themeChange)),
                  child: Text(
                    'Your account password',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
                  ),
                ),
                OutlinedCard(
                  title: 'ACCOUNT ID',
                  buttonLabel: 'Copy',
                  onPressed: () =>
                      Clipboard.setData(ClipboardData(text: FirebaseAuth.instance.currentUser.uid))
                          .then((value) => Utils.showSnackBar(
                              context, 'Your ID is copied to clipboard', themeChange)),
                  child: Text(
                    'Do not share this ID because it may contain information on '
                    'your account like your activity or password.',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
                  ),
                ),
                OutlinedCard(
                  title: 'TRUSTED DEVICES',
                  buttonLabel: 'Add',
                  onPressed: () => showDialog(
                      context: context,
                      builder: (_) => AddDeviceDialog(
                            onDone: () {
                              Utils.showSnackBar(context, 'Device Added', themeChange);
                            },
                            onContains: (trustedDevices) => Utils.showSnackBar(
                                context, 'This device is already trusted', themeChange),
                            onError: (error) =>
                                Utils.showSnackBar(context, error.message, themeChange),
                          )),
                  child: TrustedDevices(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
