import 'package:day_study/classes/dayNote.dart';
import 'package:day_study/db/dayNoteDao.dart';
import 'package:day_study/pages/editNote.dart';
import 'package:flutter/material.dart';

class RecentsCard extends StatefulWidget {
  @override
  _RecentsCardState createState() => _RecentsCardState();

  DayNote daynote;
  Function() refreshHome;

  RecentsCard({Key? key, required this.daynote, required this.refreshHome})
      : super(key: key);
}

class _RecentsCardState extends State<RecentsCard> {
  Future<void> _delete() async {
    final dbDayNotes = DayNoteDao.instance;
    final deleted = await dbDayNotes.delete(widget.daynote.id);
  }

  Future<void> _changeStarredStatus() async {
    final dbDayNotes = DayNoteDao.instance;
    Map<String, dynamic> row = {
      DayNoteDao.columnId: widget.daynote.id,
      DayNoteDao.columnStarred: widget.daynote.starred == 0 ? 1 : 0,
    };
    final update = await dbDayNotes.update(row);
  }

  showAlertDialogOkDelete(BuildContext context) {
    Widget okButton = TextButton(
      child: Text(
        "Yes",
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).accentColor),
      ),
      onPressed: () {
        _delete();
        widget.refreshHome();
      },
    );

    AlertDialog alert = AlertDialog(
      elevation: 3.0,
      title: Text(
        "Confirm", //
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      content: Text(
        "\nDelete ?",
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(3, 0, 0, 10),
          child: Column(
            children: <Widget>[
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(16, 0, 5, 0),
                title: Text(widget.daynote.day,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context)
                            .accentTextTheme
                            .headline1!
                            .color)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline_outlined,
                        size: 20,
                      ),
                      splashRadius: 26,
                      onPressed: () {
                        showAlertDialogOkDelete(context);
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 20,
                      ),
                      splashRadius: 26,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  EditNote(dayNoteEdit: widget.daynote),
                              fullscreenDialog: true,
                            )).then((value) => widget.refreshHome());
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    widget.daynote.starred == 0
                        ? IconButton(
                            icon: Icon(
                              Icons.star_outline,
                            ),
                            onPressed: () {
                              _changeStarredStatus();
                              widget.refreshHome();
                            },
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.star_border_outlined,
                              color: Theme.of(context).accentColor,
                            ),
                            onPressed: () {
                              _changeStarredStatus();
                              widget.refreshHome();
                            },
                          ),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  widget.daynote.note,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
