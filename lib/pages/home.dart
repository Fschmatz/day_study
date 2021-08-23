import 'dart:async';
import 'package:day_study/classes/dayNote.dart';
import 'package:day_study/db/dayNoteDao.dart';
import 'package:day_study/pages/newNote.dart';
import 'package:day_study/pages/pgAllEntries.dart';
import 'package:day_study/pages/pgRecent.dart';
import 'package:day_study/widgets/tileAllEntries.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'configs/settingsPage.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> dayNotesList = [];
  final dbDayNotes = DayNoteDao.instance;

  int _currentIndex = 0;
  List<Widget> _pageList = [PgRecent(),PgAllEntries(),SettingsPage()];

  @override
  Widget build(BuildContext context) {

    TextStyle styleFontNavBar =
    TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: Theme.of(context).accentColor);

    return Scaffold(
        appBar: AppBar(
          title: Text('Day Study'),
          elevation: 0,
        ),
        body: _pageList[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor!,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
            child: GNav(
              rippleColor: Theme.of(context).accentColor.withOpacity(0.4),
              hoverColor: Theme.of(context).accentColor.withOpacity(0.4),
              color: Theme.of(context)
                  .textTheme
                  .headline6!
                  .color!
                  .withOpacity(0.8),
              gap: 10,
              activeColor: Theme.of(context).accentColor,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              duration: Duration(milliseconds: 500),
              tabBackgroundColor:
              Theme.of(context).accentColor.withOpacity(0.3),
              backgroundColor:
              Theme.of(context).bottomNavigationBarTheme.backgroundColor!,
              tabs: [
                GButton(
                  icon: Icons.history_outlined,
                  text: 'Recents',
                  textStyle: styleFontNavBar,
                ),
                GButton(
                  icon: Icons.grid_view_outlined,
                  text: 'All Entries',
                  textStyle: styleFontNavBar,
                ),
                GButton(
                  icon: Icons.settings_outlined,
                  text: 'Settings',
                  textStyle: styleFontNavBar,
                ),
              ],
              selectedIndex: _currentIndex,
              onTabChange: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
