import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lpm/components/app_bar.dart';
import 'package:lpm/components/bottom_banner.dart';
import 'package:lpm/components/tool_card.dart';
import 'package:lpm/constants.dart';
import 'package:lpm/shared/data.dart';
import 'package:url_launcher/url_launcher.dart';

class ToolsScreen extends StatefulWidget {
  @override
  _ToolsScreenState createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) => Scrollbar(
              child: ListView(
                children: [
                  SizedBox(height: Constants.mainOffset(context)),
                  GridView(
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 50.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (constraints.maxWidth / 400).round(),
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      mainAxisExtent: 350,
                    ),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: _items(),
                  ),
                  SizedBox(height: Constants.bannerOffset),
                  BottomBanner(),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(24.0),
                child: MAppBar(
                  selected: MenuItem.tools,
                  onSelected: (menuItem) {
                    if (menuItem != MenuItem.tools) {
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

  List<Widget> _items() {
    DocumentSnapshot userDoc = GlobalData.instance.get('UserDoc');
    String role = userDoc.get('role');
    List<Widget> items = [
      ToolCard(
        title: 'Coming Soon...',
        details: 'Help us improve the website and submit your ideas.',
        onTap: () async {
          // Navigator.of(context).pushNamed('/tools/suggest');
          launch('mailto:aminbadh@gmail.com');
        },
        icon: Icons.extension,
      ),
    ];
    if (role == 'Manager' || role == 'Developer') {
      items.insertAll(0, [
        ToolCard(
          title: 'Attendance Register',
          details: 'The tool that makes it so easy to register the students\' attendance online.',
          onTap: () {
            Navigator.of(context).pushNamed('/tools/attendance/register/recent');
          },
          icon: Icons.group,
        ),
        ToolCard(
          title: 'Attendance Overview',
          details: 'The tool that allows you to see and analyse students\' absences',
          onTap: () {
            Navigator.of(context).pushNamed('/tools/attendance/overview');
          },
          icon: Icons.person_pin_rounded,
        ),
      ]);
    } else if (role == 'Professor') {
      items.insert(
          0,
          ToolCard(
            title: 'Attendance Register',
            details: 'The tool that makes it so easy to register the students\' attendance online.',
            onTap: () {
              Navigator.of(context).pushNamed('/tools/attendance/register/recent');
            },
            icon: Icons.group,
          ));
    } else if (role == 'Admin') {
      items.insert(
          0,
          ToolCard(
            title: 'Attendance Overview',
            details: 'The tool that allows you to see and analyse students\' absences',
            onTap: () {
              Navigator.of(context).pushNamed('/tools/attendance/overview');
            },
            icon: Icons.person_pin_rounded,
          ));
    }
    return items;
  }
}
