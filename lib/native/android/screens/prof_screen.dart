import 'dart:async';

import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lpm/native/android/screens/drawer_screen.dart';
import 'package:lpm/native/android/screens/main_screen_prof.dart';
import 'package:lpm/shared/data.dart';
import 'package:lpm/utils/strings.dart';

enum ProfItems {
  home,
  account,
  notes,
  attendanceRegister,
  marksSaver,
  testsCalender,
  settings,
}

class ProfScreen extends StatefulWidget {
  @override
  _ProfScreenState createState() => _ProfScreenState();
}

class _ProfScreenState extends State<ProfScreen> {
  final mainScreenKey = GlobalKey();
  ProfItems selected = ProfItems.home;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> trustedDevices = GlobalData.instance.get('UserDoc').get('trustedDevices');
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    return FutureBuilder(
        future: deviceInfoPlugin.androidInfo,
        builder: (context, AsyncSnapshot<AndroidDeviceInfo> info) {
          if (info.hasData) {
            String uuid = info.data.androidId;
            if (trustedDevices.containsValue(uuid)) {
              return Stack(
                children: [
                  DrawerScreen(
                    selectedTitle: title(),
                    onSelected: (item) {
                      final dynamic mainState = mainScreenKey.currentState;
                      mainState.switchState();
                      Future.delayed(
                          Duration(milliseconds: 275), () => setState(() => selected = item));
                    },
                  ),
                  MainScreenProf2(key: mainScreenKey, selected: selected),
                ],
              );
            } else {
              FirebaseAuth.instance.signOut();
              return Scaffold();
            }
          } else {
            return Scaffold();
          }
        });
  }

  String title() {
    switch (selected) {
      case ProfItems.home:
        return Strings.home;
      case ProfItems.account:
        return Strings.account;
      case ProfItems.notes:
        return Strings.notes;
      case ProfItems.attendanceRegister:
        return Strings.attRegister;
      case ProfItems.marksSaver:
        return Strings.marksSaver;
      case ProfItems.testsCalender:
        return Strings.testsCalendar;
      case ProfItems.settings:
        return Strings.settings;
      default:
        return null;
    }
  }
}
