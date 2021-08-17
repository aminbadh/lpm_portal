import 'package:flutter/material.dart';
import 'package:lpm/components/app_bar.dart';
import 'package:lpm/components/bottom_banner.dart';
import 'package:lpm/components/news_box.dart';
import 'package:lpm/constants.dart';

class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Scrollbar(
            child: ListView(
              children: [
                SizedBox(height: Constants.mainOffset(context)),
                NewsBox(
                  time: '16 hrs ago',
                  title: '88 Tunisia in now available in LPM (Place Holder)',
                  content: 'Thanks to our students, we are now happy to announce that Tunisia 88 '
                      'is now available in our high school, starting from Friday 2/04/2021. '
                      'If you want to join please head to the club managers and inform '
                      'them about that. Thanks to everyone who made that possible.',
                  imagePath: 'assets/images/tun_88.jpg',
                  author: 'The Manager',
                ),
                SizedBox(height: 16),
                NewsBox(
                  time: '1 day ago',
                  title: 'ATAST club in now available in LPM (Place Holder)',
                  content: 'We are now happy to announce that ATAST is willing to make a club '
                      'our high school, starting from Friday 2/04/2021. If you want to '
                      'join please head to the club managers and inform them about '
                      'that. Thanks to everyone who made that possible.',
                  imagePath: 'assets/images/atast.jpg',
                  author: 'The Manager',
                ),
                SizedBox(height: 24),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 5,
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Constants.primaryAccL,
                    ),
                    onPressed: () {},
                    child: Text(
                      'Load More',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
                SizedBox(height: Constants.bannerOffset - 24),
                BottomBanner(currentItem: MenuItem.news),
              ],
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(24.0),
                child: MAppBar(
                  selected: MenuItem.news,
                  onSelected: (menuItem) {
                    if (menuItem != MenuItem.news) {
                      String routeName;
                      switch (menuItem) {
                        case MenuItem.aboutUs:
                          routeName = '/about-us';
                          break;
                        case MenuItem.home:
                          routeName = '/';
                          break;
                        case MenuItem.contact:
                          routeName = '/contact';
                          break;
                        case MenuItem.account:
                          routeName = '/account';
                          break;
                        case MenuItem.news:
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
