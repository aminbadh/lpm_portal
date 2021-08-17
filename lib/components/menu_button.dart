import 'package:flutter/material.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class MenuButton extends StatefulWidget {
  final String title;
  final Function onPress;
  final bool selected;

  const MenuButton({
    Key key,
    @required this.title,
    @required this.onPress,
    @required this.selected,
  })  : assert(title != null && onPress != null && selected != null),
        super(key: key);

  @override
  _MenuButtonState createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    if (themeChange.darkTheme) {
      return MenuBD(
        title: widget.title,
        onPress: widget.onPress,
        selected: widget.selected,
      );
    } else {
      return MenuBL(
        title: widget.title,
        onPress: widget.onPress,
        selected: widget.selected,
      );
    }
  }
}

class MenuBL extends StatefulWidget {
  final String title;
  final Function onPress;
  final bool selected;

  const MenuBL({
    Key key,
    @required this.title,
    @required this.onPress,
    @required this.selected,
  })  : assert(title != null && onPress != null && selected != null),
        super(key: key);

  @override
  _MenuBLState createState() => _MenuBLState();
}

class _MenuBLState extends State<MenuBL> {
  Color color = Constants.defaultTextColorL;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          Center(
            child: InkWell(
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        color: color,
                      ),
                ),
              ),
            ),
          ),
          widget.selected
              ? LayoutBuilder(
                  builder: (context, constraints) => Container(
                    color: Constants.primaryAccL,
                    width: constraints.maxWidth / 10,
                    height: 2,
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

class MenuBD extends StatefulWidget {
  final String title;
  final Function onPress;
  final bool selected;

  const MenuBD({
    Key key,
    @required this.title,
    @required this.onPress,
    @required this.selected,
  })  : assert(title != null && onPress != null && selected != null),
        super(key: key);

  @override
  _MenuBDState createState() => _MenuBDState();
}

class _MenuBDState extends State<MenuBD> {
  Color color = Constants.defaultTextColorD;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          Center(
            child: InkWell(
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        color: color,
                      ),
                ),
              ),
            ),
          ),
          widget.selected
              ? LayoutBuilder(
                  builder: (context, constraints) => Container(
                    color: Constants.primaryAccD,
                    width: constraints.maxWidth / 10,
                    height: 2,
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
