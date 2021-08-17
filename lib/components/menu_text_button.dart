import 'package:flutter/material.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class MenuTextButton extends StatefulWidget {
  final String title;
  final Function onPress;
  final double size;

  const MenuTextButton({Key key, @required this.title, @required this.onPress, @required this.size})
      : assert(title != null && onPress != null && size != null),
        super(key: key);

  @override
  _MenuTextButtonState createState() => _MenuTextButtonState();
}

class _MenuTextButtonState extends State<MenuTextButton> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    if (themeChange.darkTheme) {
      return MenuTextBD(
        title: widget.title,
        onPress: widget.onPress,
        size: widget.size,
      );
    } else {
      return MenuTextBL(
        title: widget.title,
        onPress: widget.onPress,
        size: widget.size,
      );
    }
  }
}

class MenuTextBL extends StatefulWidget {
  final String title;
  final Function onPress;
  final double size;

  const MenuTextBL({
    Key key,
    @required this.title,
    @required this.onPress,
    @required this.size,
  })  : assert(title != null && onPress != null && size != null),
        super(key: key);

  @override
  _MenuTextBLState createState() => _MenuTextBLState();
}

class _MenuTextBLState extends State<MenuTextBL> {
  Color color = Constants.defaultTextColorL;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPress,
      onHover: (bool) {
        if (bool) {
          setState(() {
            color = Constants.primaryL;
          });
        } else {
          setState(() {
            color = Constants.defaultTextColorL;
          });
        }
      },
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Text(
        widget.title,
        style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontSize: widget.size,
              color: color,
            ),
      ),
    );
  }
}

class MenuTextBD extends StatefulWidget {
  final String title;
  final Function onPress;
  final double size;

  const MenuTextBD({
    Key key,
    @required this.title,
    @required this.onPress,
    @required this.size,
  })  : assert(title != null && onPress != null && size != null),
        super(key: key);

  @override
  _MenuTextBDState createState() => _MenuTextBDState();
}

class _MenuTextBDState extends State<MenuTextBD> {
  Color color = Constants.defaultTextColorD;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPress,
      onHover: (bool) {
        if (bool) {
          setState(() {
            color = Constants.primaryD;
          });
        } else {
          setState(() {
            color = Constants.defaultTextColorD;
          });
        }
      },
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Text(
        widget.title,
        style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontSize: widget.size,
              color: color,
            ),
      ),
    );
  }
}
