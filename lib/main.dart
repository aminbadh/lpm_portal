import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/native/android/lpm_android.dart';
import 'package:lpm/native/web/lpm_app_web.dart';

void main() async {
  // Initialise Firebase.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Run the app for the right platform.
  if (Constants.isAndroid()) {
    runApp(LPMAnd());
  } else {
    runApp(LPMWeb());
  }
}
