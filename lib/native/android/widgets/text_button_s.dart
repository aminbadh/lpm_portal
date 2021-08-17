import 'package:flutter/material.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class TextButtonS extends StatelessWidget {
  final Function onSignUp;
  final String text;

  const TextButtonS({Key key, @required this.onSignUp, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return InkWell(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onSignUp,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 4.0,
        ),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: themeChange.darkTheme ? Constants.primaryD : Constants.primaryAccL),
        ),
      ),
    );
  }
}
