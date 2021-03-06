import 'package:day_study/classes/dayNote.dart';
import 'package:day_study/db/dayNoteDao.dart';
import 'package:day_study/pages/editNote.dart';
import 'package:flutter/material.dart';

class tileAllEntries extends StatefulWidget {
  @override
  _tileAllEntriesState createState() => _tileAllEntriesState();

  DayNote daynote;
  Function() refreshHome;

  tileAllEntries({Key? key, required this.daynote, required this.refreshHome})
      : super(key: key);
}

class _tileAllEntriesState extends State<tileAllEntries> {
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
        Navigator.of(context).pop();
        Navigator.of(context).pop();
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

  //BOTTOM MENU
  openBottomMenuScrollable() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20.0),
            topRight: const Radius.circular(20.0)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.35,
          maxChildSize: widget.daynote.note.length > 400 ? 0.7 : 0.55,
          builder: (BuildContext context, myScrollController) {
            return Container(
              child: ListView(
                  controller: myScrollController,
                  shrinkWrap: true,
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                        child: Wrap(
                          children: <Widget>[
                            ListTile(
                              leading :SizedBox.shrink(),
                              title: Text("Day".toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).accentTextTheme.headline1!.color)),
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
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute<void>(
                                                builder:
                                                    (BuildContext context) =>
                                                        EditNote(
                                                            dayNoteEdit:
                                                                widget.daynote),
                                                fullscreenDialog: true,
                                              ))
                                          .then(
                                              (value) => widget.refreshHome());
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
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      : IconButton(
                                          icon: Icon(
                                            Icons.star_border_outlined,
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                          onPressed: () {
                                            _changeStarredStatus();
                                            widget.refreshHome();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                ],
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.calendar_today_outlined),
                              title: Text(
                                widget.daynote.day,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Divider(),
                            ListTile(
                              leading: SizedBox(
                                height: 0.1,
                              ),
                              title: Text("Note".toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).accentTextTheme.headline1!.color)),
                            ),
                            ListTile(
                              leading: Icon(Icons.text_snippet_outlined),
                              title: Text(
                                widget.daynote.note,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ]),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
      return ListTile(
      tileColor: Theme.of(context).cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      leading: Icon(
        Icons.calendar_today_outlined,
        size: 22,
      ),
      title: Text(widget.daynote.day,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      trailing: widget.daynote.starred == 1
          ? Icon(
              Icons.star_border_outlined,
              color: Theme.of(context).accentTextTheme.headline1!.color,
            )
          : SizedBox.shrink(),
      onTap: openBottomMenuScrollable,
    );
  }
}
