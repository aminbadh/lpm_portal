import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lpm/components/app_bar.dart';
import 'package:lpm/components/bottom_banner.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class PageNotFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          Scrollbar(
            child: ListView(
              children: [
                SizedBox(height: Constants.mainOffset(context)),
                Text(
                  '404',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ibmPlexSerif().copyWith(
                    fontSize: 46,
                    color: themeChange.darkTheme
                        ? Constants.primaryD
                        : Colors.indigo[500].withOpacity(0.9),
                  ),
                ),
                Row(
                  children: [
                    Expanded(child: Container()),
                    Text(
                      'Page Not Found',
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
                SizedBox(height: Constants.bannerOffset),
                BottomBanner(),
              ],
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(24.0),
                child: MAppBar(
                  onSelected: (menuItem) {
                    String routeName;
                    switch (menuItem) {
                      case MenuItem.aboutUs:
                        routeName = '/about-us';
                        break;
                      case MenuItem.news:
                        routeName = '/news';
                        break;
                      case MenuItem.contact:
                        routeName = '/contact';
                        break;
                      case MenuItem.account:
                        routeName = '/account';
                        break;
                      case MenuItem.home:
                        routeName = '/';
                        break;
                      case MenuItem.tools:
                        routeName = '/tools';
                        break;
                    }
                    Navigator.of(context).pushNamedAndRemoveUntil(routeName, (route) => false);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
