import 'package:flutter/material.dart';
import 'package:lpm/components/menu_text_button.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class OutlinedCard extends StatelessWidget {
  final String title;
  final String buttonLabel;
  final Function onPressed;
  final Widget child;

  const OutlinedCard(
      {Key key,
      @required this.title,
      @required this.buttonLabel,
      @required this.onPressed,
      @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.5),
          width: 1,
        ),
      ),
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        letterSpacing: 1,
                        color: themeChange.darkTheme ? Colors.grey : Colors.grey[700],
                        fontSize: 16,
                      ),
                ),
                Opacity(
                  opacity: 0.8,
                  child: MenuTextButton(
                    title: buttonLabel,
                    onPress: onPressed,
                    size: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              color: themeChange.darkTheme ? Constants.dividerColorD : Constants.dividerColorL,
              height: 1,
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
