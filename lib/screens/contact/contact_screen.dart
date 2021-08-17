import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lpm/components/app_bar.dart';
import 'package:lpm/components/bottom_banner.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class ContactScreen extends StatelessWidget {
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
                  'Contact',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ibmPlexSerif().copyWith(
                    fontSize: 46,
                    color: themeChange.darkTheme
                        ? Constants.primaryD
                        : Colors.indigo[500].withOpacity(0.9),
                  ),
                ),
                SizedBox(height: Constants.bannerOffset),
                BottomBanner(currentItem: MenuItem.contact),
              ],
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(24.0),
                child: MAppBar(
                  selected: MenuItem.contact,
                  onSelected: (menuItem) {
                    if (menuItem != MenuItem.contact) {
                      String routeName;
                      switch (menuItem) {
                        case MenuItem.aboutUs:
                          routeName = '/about-us';
                          break;
                        case MenuItem.news:
                          routeName = '/news';
                          break;
                        case MenuItem.home:
                          routeName = '/';
                          break;
                        case MenuItem.account:
                          routeName = '/account';
                          break;
                        case MenuItem.contact:
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
