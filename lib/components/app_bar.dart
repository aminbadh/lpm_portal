import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lpm/components/cool_button.dart';
import 'package:lpm/components/login_dialog.dart';
import 'package:lpm/components/menu_button.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/shared/data.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

enum MenuItem { home, aboutUs, tools, news, contact, account }
enum UserState { unknown, loggedIn, notLoggedIn }

class MAppBar extends StatefulWidget {
  final MenuItem selected;
  final Function(MenuItem) onSelected;

  const MAppBar({Key key, this.selected, @required this.onSelected}) : super(key: key);

  @override
  _MAppBarState createState() => _MAppBarState();
}

class _MAppBarState extends State<MAppBar> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var themeChange;
  FirebaseAuth _auth = FirebaseAuth.instance;
  DocumentSnapshot _userDoc;
  User _user;
  UserState userState;
  BoxConstraints _constraints;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    themeChange = Provider.of<DarkThemeProvider>(context);
    _userDoc = GlobalData.instance.get('UserDoc');

    return LayoutBuilder(
      builder: (context, constraints) {
        _constraints = constraints;
        return Card(
          color: themeChange.darkTheme ? Color(0xFF525252) : Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 46.0,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: _menuItems(constraints, 0),
                      ),
                    ),
                  ],
                ),
                constraints.maxWidth < 650
                    ? Column(
                        children: [
                          Row(children: _menuItems(constraints, 1)),
                          SizedBox(height: 8),
                        ],
                      )
                    : SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget accountMenuItem() {
    _user = _auth.currentUser;
    userState = GlobalData.instance.get('userState') ?? UserState.unknown;
    switch (userState) {
      case UserState.unknown:
        Future.delayed(Duration(seconds: 2), () {
          _user = _auth.currentUser;
          if (_user == null) {
            setState(() => userState = UserState.notLoggedIn);
            GlobalData.instance.set('userState', UserState.notLoggedIn);
          } else {
            setState(() => userState = UserState.loggedIn);
            GlobalData.instance.set('userState', UserState.loggedIn);
          }
        });
        return Flexible(
          child: Center(
            child: Container(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        );
        break;
      case UserState.loggedIn:
        _userDoc = GlobalData.instance.get('UserDoc');
        if (_userDoc == null) {
          return FutureBuilder(
            future: _db.collection('users').doc(_user.uid).get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _userDoc = snapshot.data;
                  });
                  GlobalData.instance.set('UserDoc', snapshot.data);
                  print(snapshot.data.data().toString());
                });
                return SizedBox();
                // return MenuButton(
                //   title: 'Account',
                //   onPress: () => widget.onSelected(MenuItem.account),
                //   selected: widget.selected == MenuItem.account,
                // );
              } else if (snapshot.hasError) {
                _onSignOut();
                print(snapshot.error.toString());
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                  snapshot.error.toString(),
                  style: TextStyle(
                      color: themeChange.darkTheme
                          ? Constants.textColorSnackBarD
                          : Constants.textColorSnackBarL),
                )));
                return SizedBox();
              } else {
                return Flexible(
                  child: Center(
                    child: Container(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          );
        } else {
          return MenuButton(
            title: _constraints.maxWidth > 288 ? 'Account' : 'User',
            onPress: () => widget.onSelected(MenuItem.account),
            selected: widget.selected == MenuItem.account,
          );
        }
        break;
      case UserState.notLoggedIn:
        return CoolButton(
          title: 'Sign In',
          onPress: () => showDialog(
            context: context,
            builder: (context) {
              return LoginDialog(() {
                setState(() => userState = UserState.loggedIn);
                GlobalData.instance.set('userState', UserState.loggedIn);
              });
            },
          ),
        );
        break;
    }
    return SizedBox();
  }

  void _onSignOut() {
    setState(() => userState = UserState.notLoggedIn);
    GlobalData.instance.set('userState', UserState.notLoggedIn);
  }

  List<Widget> _menuItems(BoxConstraints constraints, int index) {
    if (constraints.maxWidth > 650) {
      List<Widget> items = [
        MenuButton(
          title: 'Home',
          onPress: () => widget.onSelected(MenuItem.home),
          selected: widget.selected == MenuItem.home,
        ),
        MenuButton(
          title: 'About Us',
          onPress: () => widget.onSelected(MenuItem.aboutUs),
          selected: widget.selected == MenuItem.aboutUs,
        ),
        MenuButton(
          title: 'News',
          onPress: () => widget.onSelected(MenuItem.news),
          selected: widget.selected == MenuItem.news,
        ),
        // MenuButton(
        //   title: 'Contact',
        //   onPress: () => widget.onSelected(MenuItem.contact),
        //   selected: widget.selected == MenuItem.contact,
        // ),
        accountMenuItem(),
      ];
      if (_userDoc != null) {
        String role = _userDoc.get('role');
        if (role == 'Manager' || role == 'Developer' || role == 'Professor' || role == 'Admin') {
          items.insert(
            1,
            MenuButton(
              title: 'Tools',
              onPress: () => widget.onSelected(MenuItem.tools),
              selected: widget.selected == MenuItem.tools,
            ),
          );
        }
      }
      return items;
    } else {
      if (index == 0) {
        List<Widget> top = [
          MenuButton(
            title: 'Home',
            onPress: () => widget.onSelected(MenuItem.home),
            selected: widget.selected == MenuItem.home,
          ),
        ];
        if (_userDoc != null) {
          String role = _userDoc.get('role');
          if (role == 'Manager' || role == 'Developer' || role == 'Professor' || role == 'Admin') {
            top.insert(
              1,
              MenuButton(
                title: 'Tools',
                onPress: () => widget.onSelected(MenuItem.tools),
                selected: widget.selected == MenuItem.tools,
              ),
            );
          }
        } else {
          top.insert(
            1,
            MenuButton(
              title: 'About',
              onPress: () => widget.onSelected(MenuItem.aboutUs),
              selected: widget.selected == MenuItem.aboutUs,
            ),
          );
        }
        return top;
      } else {
        List<Widget> bottom = [
          MenuButton(
            title: 'News',
            onPress: () => widget.onSelected(MenuItem.news),
            selected: widget.selected == MenuItem.news,
          ),
          accountMenuItem(),
        ];
        if (_userDoc != null) {
          bottom.insert(
            0,
            MenuButton(
              title: 'About',
              onPress: () => widget.onSelected(MenuItem.aboutUs),
              selected: widget.selected == MenuItem.aboutUs,
            ),
          );
        }
        return bottom;
      }
    }
  }
}
