import 'dart:async';
import 'package:day_study/classes/dayNote.dart';
import 'package:day_study/db/dayNoteDao.dart';
import 'package:day_study/pages/newNote.dart';
import 'package:day_study/widgets/dayListTile.dart';
import 'package:flutter/material.dart';
import 'configs/settingsPage.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> dayNotesList = [];
  final dbDayNotes = DayNoteDao.instance;

  @override
  void initState() {
    super.initState();
    getAllDayNotes();
  }

  getCurrentDate() {
    return DateFormat('dd/MM').format(DateTime.now());
  }

  Future<void> getAllDayNotes() async {
    var resp = await dbDayNotes.queryAllRowsDesc();
    setState(() {
      dayNotesList = resp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Day Study'),
          elevation: 0,
        ),
        body: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => const Divider(),
                shrinkWrap: true,
                itemCount: dayNotesList.length,
                itemBuilder: (context, index) {
                  return DayListTile(
                    daynote: new DayNote(
                      dayNotesList[index]['id'],
                      dayNotesList[index]['day'],
                      dayNotesList[index]['note'],
                    ),
                    refreshHome: getAllDayNotes,
                    key: UniqueKey(),
                  );
                }),
          ],
        ),
        floatingActionButton: Container(
          child: FittedBox(
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).accentColor,
              elevation: 0.0,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => NewNote(),
                      fullscreenDialog: true,
                    )).then((value) => getAllDayNotes());
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          child: Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                IconButton(
                    color: Theme.of(context)
                        .textTheme
                        .headline6!
                        .color!
                        .withOpacity(0.8),
                    icon: Icon(
                      Icons.settings_outlined,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => SettingsPage(),
                            fullscreenDialog: true,
                          ));
                    }),
              ])),
        ));
  }
}
