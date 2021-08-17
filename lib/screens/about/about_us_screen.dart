import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lpm/components/app_bar.dart';
import 'package:lpm/components/bottom_banner.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class AboutUsScreen extends StatelessWidget {
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
                  'About Us',
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
                      'History of the high school and missions',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
                SizedBox(height: Constants.bannerOffset),
                BottomBanner(currentItem: MenuItem.aboutUs),
              ],
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(24.0),
                child: MAppBar(
                  selected: MenuItem.aboutUs,
                  onSelected: (menuItem) {
                    if (menuItem != MenuItem.aboutUs) {
                      String routeName;
                      switch (menuItem) {
                        case MenuItem.home:
                          routeName = '/';
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
                        case MenuItem.aboutUs:
                          break;
                        case MenuItem.tools:
                          routeName = '/tools';
                          break;
                      }
                      Navigator.of(context).pushNamedAndRemoveUntil(routeName, (route) => false);
                    }
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
