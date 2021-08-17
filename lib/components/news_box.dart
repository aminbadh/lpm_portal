import 'package:flutter/material.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class NewsBox extends StatelessWidget {
  final String time, title, content, imagePath, author;

  const NewsBox(
      {Key key,
      @required this.time,
      @required this.title,
      @required this.content,
      @required this.imagePath,
      @required this.author})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final width = MediaQuery.of(context).size.width;

    if (width > 900) {
      return Container(
        color: themeChange.darkTheme ? Colors.grey[900] : Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 48),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: 12,
                  ),
            ),
            SizedBox(height: 2),
            Text(
              title,
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  imagePath,
                  height: 300,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          content,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              author,
                              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 12),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
          ],
        ),
      );
    } else {
      return Container(
        color: themeChange.darkTheme ? Colors.grey[900] : Colors.white,
        margin: EdgeInsets.symmetric(horizontal: width / 25),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: 12,
                  ),
            ),
            SizedBox(height: 2),
            Text(
              title,
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imagePath,
                  height: width / 3,
                  width: width / 2,
                  fit: BoxFit.scaleDown,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    content,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        author,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 12),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
