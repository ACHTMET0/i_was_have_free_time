import 'package:countdownapp/alarmPage.dart';
import 'package:countdownapp/clockPage.dart';
import 'package:countdownapp/settingPage.dart';
import 'package:countdownapp/timerPage.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  State<HomePage> createState() => _HomePageState();
}

int selectedIndex = 0;
final pageController = PageController(initialPage: 0);

class _HomePageState extends State<HomePage> {
  final screens = [
    CountdownPage(),
    ClockPage(),
    alarmPage(),
    settingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: SalomonBottomBar(
          currentIndex: selectedIndex,
          onTap: ((value) => pageController.animateToPage(value,
              duration: Duration(microseconds: 300), curve: Curves.easeIn)),
          items: [
            SalomonBottomBarItem(
              icon: Icon(Icons.timer_outlined),
              activeIcon: Icon(Icons.timer),
              title: Text("Timer"),
              selectedColor: Colors.black,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.access_time_outlined),
              activeIcon: Icon(Icons.access_time_filled_sharp),
              title: Text("Clock"),
              selectedColor: Colors.black,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.alarm),
              activeIcon: Icon(Icons.alarm_sharp),
              title: Text("Alarm"),
              selectedColor: Colors.black,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              title: Text("Settings"),
              selectedColor: Colors.black,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: (value) => setState(() {
            selectedIndex = value;
          }),
          children: screens,
        ),
      ),
    );
  }
}
