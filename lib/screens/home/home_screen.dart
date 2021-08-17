import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lpm/components/app_bar.dart';
import 'package:lpm/components/bottom_banner.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/utils/dark_theme_prefs.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Perform To Learn',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ibmPlexSerif().copyWith(
                      fontSize: 46,
                      color: themeChange.darkTheme
                          ? Constants.primaryD
                          : Colors.indigo[500].withOpacity(0.9),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(child: Container()),
                    Text(
                      'That\'s a place holder text',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
                // Container(
                //   height: MediaQuery.of(context).size.height,
                //   width: MediaQuery.of(context).size.width,
                //   decoration: const BoxDecoration(
                //     image: DecorationImage(
                //       alignment: Alignment(-.2, 0),
                //       image: AssetImage('assets/images/wallpaper.jpg'),
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
                SizedBox(height: Constants.bannerOffset),
                BottomBanner(currentItem: MenuItem.home),
              ],
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(24.0),
                child: MAppBar(
                  selected: MenuItem.home,
                  onSelected: (menuItem) {
                    if (menuItem != MenuItem.home) {
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
