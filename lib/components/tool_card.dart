import 'package:flutter/material.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class ToolCard extends StatelessWidget {
  final String title;
  final String details;
  final Function onTap;
  final IconData icon;

  const ToolCard({
    Key key,
    @required this.title,
    @required this.details,
    @required this.onTap,
    @required this.icon,
  })  : assert(title != null && details != null && onTap != null && icon != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Container(
      child: InkWell(
        onTap: onTap,
        child: Card(
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    height: 152,
                    child: Center(
                        child: Icon(
                      icon,
                      size: 128,
                      color: themeChange.darkTheme ? Constants.primaryD : Constants.primaryAccL,
                    )),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      details,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  )
                ],
              ),
              icon == Icons.extension
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          'The email will be sent to the website\'s developer',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
