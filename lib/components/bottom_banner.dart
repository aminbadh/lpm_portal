import 'package:flutter/material.dart';
import 'package:lpm/components/app_bar.dart';
import 'package:lpm/components/menu_text_button.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomBanner extends StatelessWidget {
  final MenuItem currentItem;

  const BottomBanner({this.currentItem});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 30,
                ),
                color: themeChange.darkTheme ? Constants.dividerColorD : Constants.dividerColorL,
                height: 1,
              ),
              SizedBox(height: 16),
              constraints.maxWidth > 900
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 250,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Lycée Pilote Monastir',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'A prestigious, innovative and elitist secondary '
                                'education establishment created in September 15, 2004',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              // SizedBox(height: 8),
                              // Image.asset(
                              //   'assets/images/google-play-badge.png',
                              //   height: 64,
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(width: 32),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Menu',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(height: 16),
                            MenuTextButton(
                              title: 'Home',
                              size: 14,
                              onPress: () {
                                if (currentItem != MenuItem.home) {
                                  Navigator.of(context).pushNamed('/');
                                }
                              },
                            ),
                            SizedBox(height: 8),
                            MenuTextButton(
                              title: 'About Us',
                              size: 14,
                              onPress: () {
                                if (currentItem != MenuItem.aboutUs) {
                                  Navigator.of(context).pushNamed('/about-us');
                                }
                              },
                            ),
                            SizedBox(height: 8),
                            MenuTextButton(
                              title: 'News',
                              size: 14,
                              onPress: () {
                                if (currentItem != MenuItem.news) {
                                  Navigator.of(context).pushNamed('/news');
                                }
                              },
                            ),
                            // SizedBox(height: 8),
                            // MenuTextButton(
                            //   title: 'Contact',
                            //   size: 14,
                            //   onPress: () {
                            //     if (currentItem != MenuItem.contact) {
                            //       Navigator.of(context).pushNamed('/contact');
                            //     }
                            //   },
                            // ),
                          ],
                        ),
                        SizedBox(width: 32),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Useful Links',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(height: 16),
                            MenuTextButton(
                              title: 'Facebook page',
                              size: 14,
                              onPress: () => launch('https://www.facebook.com/LPM.monastir'),
                            ),
                            SizedBox(height: 8),
                            MenuTextButton(
                              title: 'Discord Server',
                              size: 14,
                              onPress: () =>
                                  // launch('https://discord.gg/nrR2Vgj'),
                                  ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  width: MediaQuery.of(context).size.width / 2,
                                  content: Text(
                                    'Discord server will be available soon',
                                    style: TextStyle(
                                        color: themeChange.darkTheme
                                            ? Constants.textColorSnackBarD
                                            : Constants.textColorSnackBarL),
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              ),
                            ),
                            // SizedBox(height: 8),
                            // MenuTextButton(
                            //   title: 'FAQ',
                            //   size: 14,
                            //   onPress: () {
                            //     ScaffoldMessenger.of(context).showSnackBar(
                            //       SnackBar(
                            //         behavior: SnackBarBehavior.floating,
                            //         width:
                            //             MediaQuery.of(context).size.width / 2,
                            //         content: Text(
                            //           'Frequently asked questions page will be available soon',
                            //           style: TextStyle(
                            //               color: themeChange.darkTheme
                            //                   ? Constants.textColorSnackBarD
                            //                   : Constants.textColorSnackBarL),
                            //         ),
                            //         duration: Duration(seconds: 2),
                            //       ),
                            //     );
                            //   },
                            // ),
                          ],
                        ),
                        SizedBox(width: 32),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Contact',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(height: 16),
                            MenuTextButton(
                              title: 'Address: av. Taieb M’hiri, 5000 Monastir,\nTunisia',
                              size: 14,
                              onPress: () => launch(
                                  'https://www.google.com/maps/search/?api=1&query=35.767447819167884,10.823994053960607'),
                            ),
                            SizedBox(height: 8),
                            MenuTextButton(
                              title: 'Phone: +216 73 465 166',
                              size: 14,
                              onPress: () => launch('tel:+21673465166'),
                            ),
                            SizedBox(height: 8),
                            MenuTextButton(
                              title: 'Email: lyceepilotemfcmonastir@gmail.com',
                              size: 14,
                              onPress: () => launch('mailto:lyceepilotemfcmonastir@gmail.com'),
                            ),
                          ],
                        ),
                      ],
                    )
                  : constraints.maxWidth > 500
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  flex: ((1 / MediaQuery.of(context).size.width) * 10000).round(),
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Lycée Pilote Monastir',
                                          style: Theme.of(context).textTheme.headline5,
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'A prestigious, innovative and elitist\nsecondary '
                                          'education establishment\ncreated in September 15, 2004',
                                          style: Theme.of(context).textTheme.bodyText1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 10,
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Menu',
                                          style: Theme.of(context).textTheme.headline6,
                                        ),
                                        SizedBox(height: 16),
                                        MenuTextButton(
                                          title: 'Home',
                                          size: 14,
                                          onPress: () {
                                            if (currentItem != MenuItem.home) {
                                              Navigator.of(context).pushNamed('/');
                                            }
                                          },
                                        ),
                                        SizedBox(height: 8),
                                        MenuTextButton(
                                          title: 'About Us',
                                          size: 14,
                                          onPress: () {
                                            if (currentItem != MenuItem.aboutUs) {
                                              Navigator.of(context).pushNamed('/about-us');
                                            }
                                          },
                                        ),
                                        SizedBox(height: 8),
                                        MenuTextButton(
                                          title: 'News',
                                          size: 14,
                                          onPress: () {
                                            if (currentItem != MenuItem.news) {
                                              Navigator.of(context).pushNamed('/news');
                                            }
                                          },
                                        ),
                                        // SizedBox(height: 8),
                                        // MenuTextButton(
                                        //   title: 'Contact',
                                        //   size: 14,
                                        //   onPress: () {
                                        //     if (currentItem !=
                                        //         MenuItem.contact) {
                                        //       Navigator.of(context)
                                        //           .pushNamed('/contact');
                                        //     }
                                        //   },
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  flex: ((1 / MediaQuery.of(context).size.width) * 10000).round(),
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Contact',
                                          style: Theme.of(context).textTheme.headline6,
                                        ),
                                        SizedBox(height: 16),
                                        MenuTextButton(
                                          title:
                                              'Address: av. Taieb M’hiri, 5000 Monastir,\nTunisia',
                                          size: 14,
                                          onPress: () => launch(
                                              'https://www.google.com/maps/search/?api=1&query=35.767447819167884,10.823994053960607'),
                                        ),
                                        SizedBox(height: 8),
                                        MenuTextButton(
                                          title: 'Phone: +216 73 465 166',
                                          size: 14,
                                          onPress: () => launch('tel:+21673465166'),
                                        ),
                                        SizedBox(height: 8),
                                        MenuTextButton(
                                          title: 'Email: lyceepilotemfcmonastir@gmail.com',
                                          size: 14,
                                          onPress: () =>
                                              launch('mailto:lyceepilotemfcmonastir@gmail.com'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 10,
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Useful Links',
                                          style: Theme.of(context).textTheme.headline6,
                                        ),
                                        SizedBox(height: 16),
                                        MenuTextButton(
                                          title: 'Facebook page',
                                          size: 14,
                                          onPress: () =>
                                              launch('https://www.facebook.com/LPM.monastir'),
                                        ),
                                        SizedBox(height: 8),
                                        MenuTextButton(
                                          title: 'Community',
                                          size: 14,
                                          onPress: () {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                behavior: SnackBarBehavior.floating,
                                                width: MediaQuery.of(context).size.width / 2,
                                                content: Text(
                                                  'No community is available yet',
                                                  style: TextStyle(
                                                      color: themeChange.darkTheme
                                                          ? Constants.textColorSnackBarD
                                                          : Constants.textColorSnackBarL),
                                                ),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(height: 8),
                                        MenuTextButton(
                                          title: 'FAQ',
                                          size: 14,
                                          onPress: () {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                behavior: SnackBarBehavior.floating,
                                                width: MediaQuery.of(context).size.width / 2,
                                                content: Text(
                                                  'Frequently asked questions page will be available soon',
                                                  style: TextStyle(
                                                      color: themeChange.darkTheme
                                                          ? Constants.textColorSnackBarD
                                                          : Constants.textColorSnackBarL),
                                                ),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 250,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Lycée Pilote Monastir',
                                    style: Theme.of(context).textTheme.headline5,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'A prestigious, innovative and elitist secondary '
                                    'education establishment created in September 15, 2004',
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Menu',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                SizedBox(height: 4),
                                MenuTextButton(
                                  title: 'Home',
                                  size: 14,
                                  onPress: () {
                                    if (currentItem != MenuItem.home) {
                                      Navigator.of(context).pushNamed('/');
                                    }
                                  },
                                ),
                                SizedBox(height: 4),
                                MenuTextButton(
                                  title: 'About Us',
                                  size: 14,
                                  onPress: () {
                                    if (currentItem != MenuItem.aboutUs) {
                                      Navigator.of(context).pushNamed('/about-us');
                                    }
                                  },
                                ),
                                SizedBox(height: 4),
                                MenuTextButton(
                                  title: 'News',
                                  size: 14,
                                  onPress: () {
                                    if (currentItem != MenuItem.news) {
                                      Navigator.of(context).pushNamed('/news');
                                    }
                                  },
                                ),
                                // SizedBox(height: 4),
                                // MenuTextButton(
                                //   title: 'Contact',
                                //   size: 14,
                                //   onPress: () {
                                //     if (currentItem != MenuItem.contact) {
                                //       Navigator.of(context)
                                //           .pushNamed('/contact');
                                //     }
                                //   },
                                // ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Useful Links',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                SizedBox(height: 6),
                                MenuTextButton(
                                  title: 'Facebook page',
                                  size: 14,
                                  onPress: () => launch('https://www.facebook.com/LPM.monastir'),
                                ),
                                SizedBox(height: 4),
                                MenuTextButton(
                                  title: 'Community',
                                  size: 14,
                                  onPress: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        width: MediaQuery.of(context).size.width / 2,
                                        content: Text(
                                          'No community is available yet',
                                          style: TextStyle(
                                              color: themeChange.darkTheme
                                                  ? Constants.textColorSnackBarD
                                                  : Constants.textColorSnackBarL),
                                        ),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 4),
                                MenuTextButton(
                                  title: 'FAQ',
                                  size: 14,
                                  onPress: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        width: MediaQuery.of(context).size.width / 2,
                                        content: Text(
                                          'Frequently asked questions page will be available soon',
                                          style: TextStyle(
                                              color: themeChange.darkTheme
                                                  ? Constants.textColorSnackBarD
                                                  : Constants.textColorSnackBarL),
                                        ),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Contact',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                SizedBox(height: 4),
                                MenuTextButton(
                                  title: 'Address: av. Taieb M’hiri, 5000 Monastir,\nTunisia',
                                  size: 14,
                                  onPress: () => launch(
                                      'https://www.google.com/maps/search/?api=1&query=35.767447819167884,10.823994053960607'),
                                ),
                                SizedBox(height: 4),
                                MenuTextButton(
                                  title: 'Phone: +216 73 465 166',
                                  size: 14,
                                  onPress: () => launch('tel:+21673465166'),
                                ),
                                SizedBox(height: 4),
                                MenuTextButton(
                                  title: 'Email: lyceepilotemfcmonastir@gmail.com',
                                  size: 14,
                                  onPress: () => launch('mailto:lyceepilotemfcmonastir@gmail.com'),
                                ),
                              ],
                            ),
                          ],
                        ),
              SizedBox(height: 16),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 30,
                ),
                color: themeChange.darkTheme ? Constants.dividerColorD : Constants.dividerColorL,
                height: 1,
              ),
              SizedBox(height: 16),
              constraints.maxWidth > 600
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Copyrights ©2021 All rights reserved',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontSize: 12,
                              ),
                        ),
                        MenuTextButton(
                          title: themeChange.darkTheme ? 'Light Mode' : 'Dark Mode',
                          onPress: () {
                            themeChange.darkTheme = !themeChange.darkTheme;
                          },
                          size: 12,
                        ),
                        MenuTextButton(
                          title: 'Made with Flutter',
                          onPress: () => launch('https://itsallwidgets.com/'),
                          size: 12,
                        ),
                        Text(
                          'Made by BADH',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontSize: 12,
                              ),
                        ),
                      ],
                    )
                  : constraints.maxWidth > 375
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Copyrights ©2021 All rights reserved',
                                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                                        fontSize: 12,
                                      ),
                                ),
                                SizedBox(height: 4),
                                MenuTextButton(
                                  title: 'Made with Flutter',
                                  onPress: () => launch('https://itsallwidgets.com/'),
                                  size: 12,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                MenuTextButton(
                                  title: themeChange.darkTheme ? 'Light Mode' : 'Dark Mode',
                                  onPress: () {
                                    themeChange.darkTheme = !themeChange.darkTheme;
                                  },
                                  size: 12,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Made by BADH',
                                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                                        fontSize: 12,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Text(
                              'Copyrights ©2021 All rights reserved',
                              style: Theme.of(context).textTheme.bodyText1.copyWith(
                                    fontSize: 12,
                                  ),
                            ),
                            SizedBox(height: 4),
                            MenuTextButton(
                              title: themeChange.darkTheme ? 'Light Mode' : 'Dark Mode',
                              onPress: () {
                                themeChange.darkTheme = !themeChange.darkTheme;
                              },
                              size: 12,
                            ),
                            SizedBox(height: 4),
                            MenuTextButton(
                              title: 'Made with Flutter',
                              onPress: () => launch('https://itsallwidgets.com'),
                              size: 12,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Made by BADH',
                              style: Theme.of(context).textTheme.bodyText1.copyWith(
                                    fontSize: 12,
                                  ),
                            ),
                          ],
                        ),
            ],
          ),
        );
      },
    );
  }
}
