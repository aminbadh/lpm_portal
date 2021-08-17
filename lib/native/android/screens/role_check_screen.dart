import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/native/android/screens/prof_screen.dart';
import 'package:lpm/native/android/widgets/widgets.dart';
import 'package:lpm/shared/data.dart';

class RoleCheckScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          GlobalData.instance.set('UserDoc', snapshot.data);
          String role = snapshot.data.get('role');
          if (role == Constants.student) {
            return Scaffold();
          } else if (role == Constants.teacher) {
            return ProfScreen();
          } else if (role == Constants.admin) {
            return Scaffold();
          } else if (role == Constants.manager) {
            return Scaffold();
          } else if (role == Constants.developer) {
            return Scaffold();
          } else {
            FirebaseAuth.instance.signOut();
            return Scaffold();
          }
        } else {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.grey[50],
              statusBarIconBrightness: Brightness.dark,
            ),
            child: LoadingScreen(),
          );
        }
      },
    );
  }
}
