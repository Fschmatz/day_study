import 'dart:async';
import 'package:day_study/classes/dayNote.dart';
import 'package:day_study/db/dayNoteDao.dart';
import 'package:day_study/pages/newNote.dart';
import 'package:day_study/widgets/recentsCard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PgRecent extends StatefulWidget {
  @override
  _PgRecentState createState() => _PgRecentState();
}

class _PgRecentState extends State<PgRecent> {
  List<Map<String, dynamic>> dayNotesList = [];
  final dbDayNotes = DayNoteDao.instance;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getRecents();
  }

  getCurrentDate() {
    return DateFormat('dd/MM').format(DateTime.now());
  }

  Future<void> getRecents() async {
    var resp = await dbDayNotes.queryRecents();
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
            : ListView(physics: AlwaysScrollableScrollPhysics(), children: [
                ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(height: 12,),
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: dayNotesList.length,
                  itemBuilder: (context, index) {
                    return RecentsCard(
                      daynote: new DayNote(
                        dayNotesList[index]['id'],
                        dayNotesList[index]['day'],
                        dayNotesList[index]['note'],
                        dayNotesList[index]['starred'] == null
                            ? 0
                            : dayNotesList[index]['starred'],
                      ),
                      refreshHome: getRecents,
                    );
                  },
                ),
                const SizedBox(
                  height: 100,
                ),
              ]),
      ),
      floatingActionButton: Container(
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => NewNote(),
                  fullscreenDialog: true,
                )).then((value) => getRecents());
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
