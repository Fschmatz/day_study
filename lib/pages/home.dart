import 'dart:async';
import 'package:day_study/pages/newNote.dart';
import 'package:day_study/widgets/dayCard.dart';
import 'package:flutter/material.dart';
import 'configs/settingsPage.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Map<String, dynamic>> moods = [];

  @override
  void initState() {
    super.initState();
   // getAllDayNotes();
  }

  getCurrentDate() {
    return DateFormat('dd/MM').format(DateTime.now());

    //getCurrentDate().toString()
  }

  /*Future<void> getAllDayNotes() async {
    var resp = await db.queryAllRowsDesc();
    setState(() {
      moods = resp;
    });
  }*/

 /*
  Future<void> _saveMood(String name, String color) async {
    setState(() {
      moods = moodsEmptyAnim;
    });
    Map<String, dynamic> row = {
      MoodDao.columnName: name,
      MoodDao.columnColor: color,
    };
    final id = await db.insert(row);
  }

  Future<void> _delete(int id) async {
    final deleted = await db.delete(id);
    getAllCounts();
  }*/

  //BOTTOM MENU
  void bottomMenuAddMood(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: ListTile(title: Text("Day X:",textAlign: TextAlign.center,style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600),),
                  ),
                ),
              ],
            ),
          );
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
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: GridView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: moods.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return DayCard(
                        day: '06/06',
                        id: index
                    );
                  }),
            ),
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
                    ));
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
