import 'package:flutter/material.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class Title1 extends StatelessWidget {
  final String text;

  const Title1({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Text(
      text,
      style: Theme.of(context).textTheme.headline4.copyWith(
            letterSpacing: 1,
            color: themeChange.darkTheme ? Color(0xFFB8BCE7) : Color(0xFF1C2367),
          ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final String imagePath;
  final bool selected;
  final Function onPressed;

  const DrawerItem({
    Key key,
    @required this.text,
    this.icon,
    this.imagePath,
    @required this.selected,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return ListTile(
      title: Text(
        text,
        style: Theme.of(context).textTheme.bodyText1.copyWith(
            color: selected
                ? themeChange.darkTheme
                    ? Constants.primaryD
                    : Constants.primaryL
                : themeChange.darkTheme
                    ? Constants.defaultTextColorD
                    : Constants.defaultTextColorL),
      ),
      leading: imagePath == null
          ? Icon(
              icon,
              color: selected
                  ? themeChange.darkTheme
                      ? Constants.primaryD
                      : Constants.primaryL
                  : themeChange.darkTheme
                      ? Constants.defaultTextColorD
                      : Constants.defaultTextColorL,
            )
          : ImageIcon(AssetImage(imagePath)),
      onTap: onPressed,
    );
  }
}

class DrawerGroup extends StatelessWidget {
  final String text;

  const DrawerGroup({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: themeChange.darkTheme ? Colors.grey[300] : Colors.grey[700],
              letterSpacing: 1,
            ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 64,
          width: 64,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
          ),
        ),
      ),
    );
  }
}
