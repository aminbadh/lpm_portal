import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class CoolButton extends StatefulWidget {
  final String title;
  final Function onPress;

  const CoolButton({
    Key key,
    @required this.title,
    @required this.onPress,
  })  : assert(title != null && onPress != null),
        super(key: key);

  @override
  _CoolButtonState createState() => _CoolButtonState();
}

class _CoolButtonState extends State<CoolButton> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    if (themeChange.darkTheme) {
      return CoolBD(
        title: widget.title,
        onPress: widget.onPress,
      );
    } else {
      return CoolBL(
        title: widget.title,
        onPress: widget.onPress,
      );
    }
  }
}

class CoolBL extends StatefulWidget {
  final String title;
  final Function onPress;

  const CoolBL({
    Key key,
    @required this.title,
    @required this.onPress,
  })  : assert(title != null && onPress != null),
        super(key: key);

  @override
  _CoolBLState createState() => _CoolBLState();
}

class _CoolBLState extends State<CoolBL> {
  Color color = Colors.grey[900];

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Center(
        child: InkWell(
          onTap: widget.onPress,
          onHover: (bool) {
            if (bool) {
              setState(() {
                color = Constants.primaryL;
              });
            } else {
              setState(() {
                color = Colors.grey[900];
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
              style: GoogleFonts.ibmPlexSerif().copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CoolBD extends StatefulWidget {
  final String title;
  final Function onPress;

  const CoolBD({
    Key key,
    @required this.title,
    @required this.onPress,
  })  : assert(title != null && onPress != null),
        super(key: key);

  @override
  _CoolBDState createState() => _CoolBDState();
}

class _CoolBDState extends State<CoolBD> {
  Color color = Colors.grey[50];

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Center(
        child: InkWell(
          onTap: widget.onPress,
          onHover: (bool) {
            if (bool) {
              setState(() {
                color = Constants.primaryD;
              });
            } else {
              setState(() {
                color = Colors.grey[50];
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
              style: GoogleFonts.ibmPlexSerif().copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
