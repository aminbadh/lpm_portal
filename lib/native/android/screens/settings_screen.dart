import 'package:flutter/material.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/native/android/widgets/widgets.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    darkMode = themeChange.darkTheme;

    return ListView(
      children: [
        SizedBox(height: 4),
        DrawerGroup(text: 'APPEARANCE'),
        ListTile(
          title: Text('Dark Mode',
              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16)),
          subtitle: Text(
            themeChange.darkTheme ? 'Enable light mode' : 'Enable dark mode',
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: themeChange.darkTheme ? Colors.grey[400] : Colors.grey[600]),
          ),
          trailing: Switch(
            value: darkMode,
            onChanged: (value) => themeChange.darkTheme = !themeChange.darkTheme,
            activeColor: Constants.primaryAccD,
          ),
          onTap: () => themeChange.darkTheme = !themeChange.darkTheme,
        ),
        SizedBox(height: 4),
        DrawerGroup(text: 'CONTACT'),
        ListTile(
          title: Text('Report A Bug',
              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16)),
          subtitle: Text(
            'Developer contact',
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: themeChange.darkTheme ? Colors.grey[400] : Colors.grey[600]),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.open_in_new,
                size: 18,
                color: themeChange.darkTheme ? Constants.greyD : Constants.greyL,
              ),
              SizedBox(width: 8),
            ],
          ),
          onTap: () => launch('mailto:aminbadh@gmail.com'),
        ),
      ],
    );
  }
}
