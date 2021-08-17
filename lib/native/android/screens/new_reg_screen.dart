import 'package:flutter/material.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/screens/tools/attendance_register/new_registration.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class NewRegistrationAndroid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Add New',
          style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 18),
        ),
        elevation: 0,
        iconTheme: IconThemeData(
          color: themeChange.darkTheme ? Constants.defaultTextColorD : Constants.defaultTextColorL,
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 1,
            color: themeChange.darkTheme ? Constants.dividerColorD : Constants.dividerColorL,
          ),
          Expanded(child: NewRegistrationContent(isAndroid: true)),
        ],
      ),
    );
  }
}
