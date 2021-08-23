import 'dart:async';
import 'package:day_study/classes/dayNote.dart';
import 'package:day_study/db/dayNoteDao.dart';
import 'package:day_study/widgets/tileAllEntries.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PgAllEntries extends StatefulWidget {
  @override
  _PgAllEntriesState createState() => _PgAllEntriesState();
}

class _PgAllEntriesState extends State<PgAllEntries> {
  List<Map<String, dynamic>> dayNotesList = [];
  final dbDayNotes = DayNoteDao.instance;
  bool loading = true;

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
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedSwitcher(
      duration: Duration(milliseconds: 600),
      child: loading
          ? Center(child: SizedBox.shrink())
          : ListView(
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: GridView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: dayNotesList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3.3,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 15,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return tileAllEntries(
                          daynote: new DayNote(
                            dayNotesList[index]['id'],
                            dayNotesList[index]['day'],
                            dayNotesList[index]['note'],
                            dayNotesList[index]['starred'] == null
                                ? 0
                                : dayNotesList[index]['starred'],
                          ),
                          refreshHome: getAllDayNotes,
                          key: UniqueKey(),
                        );
                      }),
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
    ));
  }
}
