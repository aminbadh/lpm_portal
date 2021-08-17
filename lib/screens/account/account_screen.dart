import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpm/components/app_bar.dart';
import 'package:lpm/components/bottom_banner.dart';
import 'package:lpm/components/change_email_dialog.dart';
import 'package:lpm/components/change_name_dialog.dart';
import 'package:lpm/components/cool_button.dart';
import 'package:lpm/components/menu_text_button.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/shared/data.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  DarkThemeProvider themeChange;
  DocumentSnapshot userDoc;

  @override
  Widget build(BuildContext context) {
    themeChange = Provider.of<DarkThemeProvider>(context);
    userDoc = GlobalData.instance.get('UserDoc');

    return Scaffold(
      body: Stack(
        children: [
          Scrollbar(
            child: ListView(
              children: _items(context),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(24.0),
                child: MAppBar(
                  selected: MenuItem.account,
                  onSelected: (menuItem) {
                    if (menuItem != MenuItem.account) {
                      String routeName;
                      switch (menuItem) {
                        case MenuItem.aboutUs:
                          routeName = '/about-us';
                          break;
                        case MenuItem.news:
                          routeName = '/news';
                          break;
                        case MenuItem.contact:
                          routeName = '/contact';
                          break;
                        case MenuItem.home:
                          routeName = '/';
                          break;
                        case MenuItem.account:
                          break;
                        case MenuItem.tools:
                          routeName = '/tools';
                          break;
                      }
                      Navigator.of(context).pushNamedAndRemoveUntil(routeName, (route) => false);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _nameCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'YOUR NAME',
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        letterSpacing: 1,
                        color: themeChange.darkTheme ? Colors.grey : Colors.grey[700],
                        fontSize: 16,
                      ),
                ),
                Opacity(
                  opacity: 0.8,
                  child: MenuTextButton(
                    title: 'Edit',
                    onPress: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ChangeNameDialog(
                            () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  width: MediaQuery.of(context).size.width / 2,
                                  content: Text(
                                    'Request sent, changes will be applied soon.',
                                    style: TextStyle(
                                        color: themeChange.darkTheme
                                            ? Constants.textColorSnackBarD
                                            : Constants.textColorSnackBarL),
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              setState(() {});
                            },
                          );
                        },
                      );
                    },
                    size: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              color: themeChange.darkTheme ? Constants.dividerColorD : Constants.dividerColorL,
              height: 1,
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                userDoc == null ? '' : '${userDoc.get('firstName')} ${userDoc.get('lastName')}',
                style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emailCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'EMAIL',
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        letterSpacing: 1,
                        color: themeChange.darkTheme ? Colors.grey : Colors.grey[700],
                        fontSize: 16,
                      ),
                ),
                Opacity(
                  opacity: 0.8,
                  child: MenuTextButton(
                    title: 'Change email',
                    onPress: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ChangeEmailDialog(
                            () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  width: MediaQuery.of(context).size.width / 2,
                                  content: Text(
                                    'Email Address changed successfully.',
                                    style: TextStyle(
                                        color: themeChange.darkTheme
                                            ? Constants.textColorSnackBarD
                                            : Constants.textColorSnackBarL),
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              setState(() {});
                            },
                          );
                        },
                      );
                    },
                    size: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              color: themeChange.darkTheme ? Constants.dividerColorD : Constants.dividerColorL,
              height: 1,
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                FirebaseAuth.instance.currentUser == null
                    ? ''
                    : '${FirebaseAuth.instance.currentUser.email}',
                style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _passwordCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PASSWORD',
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        letterSpacing: 1,
                        color: themeChange.darkTheme ? Colors.grey : Colors.grey[700],
                        fontSize: 16,
                      ),
                ),
                Opacity(
                  opacity: 0.8,
                  child: MenuTextButton(
                    title: 'Change password',
                    onPress: () {
                      FirebaseAuth.instance
                          .sendPasswordResetEmail(email: FirebaseAuth.instance.currentUser.email)
                          .then(
                        (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              width: MediaQuery.of(context).size.width / 2,
                              content: Text(
                                'Password reset email is sent to your current email.',
                                style: TextStyle(
                                    color: themeChange.darkTheme
                                        ? Constants.textColorSnackBarD
                                        : Constants.textColorSnackBarL),
                              ),
                              duration: Duration(seconds: 5),
                            ),
                          );
                        },
                        onError: (error) {
                          print(error.toString());
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            width: MediaQuery.of(context).size.width / 2,
                            content: Text(
                              error.toString(),
                              style: TextStyle(
                                  color: themeChange.darkTheme
                                      ? Constants.textColorSnackBarD
                                      : Constants.textColorSnackBarL),
                            ),
                            duration: Duration(seconds: 2),
                          );
                        },
                      );
                    },
                    size: 16,
                  ),
                )
              ],
            ),
            SizedBox(height: 8),
            Container(
              color: themeChange.darkTheme ? Constants.dividerColorD : Constants.dividerColorL,
              height: 1,
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'Your account password',
                style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _idCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'YOUR ACCOUNT ID',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    letterSpacing: 1,
                    color: themeChange.darkTheme ? Colors.grey : Colors.grey[700],
                    fontSize: 16,
                  ),
            ),
            SizedBox(height: 8),
            Container(
              color: themeChange.darkTheme ? Constants.dividerColorD : Constants.dividerColorL,
              height: 1,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      "Do not share this ID because it may contain information on "
                      "your account like your activity or password",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: FirebaseAuth.instance.currentUser.uid))
                        .then(
                      (value) => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          width: MediaQuery.of(context).size.width / 2,
                          content: Text(
                            'Your ID is copied to clipboard',
                            style: TextStyle(
                                color: themeChange.darkTheme
                                    ? Constants.textColorSnackBarD
                                    : Constants.textColorSnackBarL),
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      'COPY ID',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            letterSpacing: 2,
                            color: themeChange.darkTheme ? Constants.primaryD : Constants.primaryL,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _items(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    List<Widget> items = [
      SizedBox(height: Constants.mainOffset(context) - 22),
      Padding(
        padding: EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: MediaQuery.of(context).size.width / 20,
        ),
        child: Text(
          userDoc == null ? '' : 'Hi ${userDoc.get('firstName')}',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 30,
        ),
        color: themeChange.darkTheme ? Constants.dividerColorD : Constants.dividerColorL,
        height: 1,
      ),
      SizedBox(height: 24),
      Row(
        children: [
          CoolButton(
            title: 'Sign out',
            onPress: () {
              FirebaseAuth.instance.signOut().then((value) {
                GlobalData.instance.set('userState', UserState.notLoggedIn);
                GlobalData.instance.set('UserDoc', null);
                setState(() {});
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              });
            },
          ),
        ],
      ),
      SizedBox(height: 16),
      BottomBanner(currentItem: MenuItem.account),
    ];
    if (width > 1000) {
      items.insertAll(
        3,
        [
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: MediaQuery.of(context).size.width / 20,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _nameCard()),
                    SizedBox(width: MediaQuery.of(context).size.width / 50),
                    Expanded(child: _emailCard()),
                    SizedBox(width: MediaQuery.of(context).size.width / 50),
                    Expanded(child: _passwordCard()),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.width / 150),
                _idCard(),
              ],
            ),
          ),
        ],
      );
    } else {
      items.insertAll(
        3,
        [
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: MediaQuery.of(context).size.width / 20,
            ),
            child: _nameCard(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: MediaQuery.of(context).size.width / 20,
            ),
            child: _emailCard(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: MediaQuery.of(context).size.width / 20,
            ),
            child: _passwordCard(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: MediaQuery.of(context).size.width / 20,
            ),
            child: _idCard(),
          ),
        ],
      );
    }
    return items;
  }
}
