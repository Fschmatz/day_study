import 'package:day_study/classes/dayNote.dart';
import 'package:day_study/db/dayNoteDao.dart';
import 'package:day_study/pages/editNote.dart';
import 'package:day_study/pages/newNote.dart';
import 'package:flutter/material.dart';

class DayListTile extends StatefulWidget {
  @override
  _DayListTileState createState() => _DayListTileState();

  DayNote daynote;
  Function() refreshHome;

  DayListTile({Key? key, required this.daynote,required this.refreshHome})
      : super(key: key);
}

class _DayListTileState extends State<DayListTile> {

  Future<void> _delete() async {
    final dbDayNotes = DayNoteDao.instance;
    final deleted = await dbDayNotes.delete(widget.daynote.id);
  }

  showAlertDialogOkDelete(BuildContext context) {
    Widget okButton = TextButton(
      child: Text(
        "Yes",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        _delete();
        widget.refreshHome();
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
  void openBottomMenu() {
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
              child: Wrap(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: ListTile(
                      leading: SizedBox(
                        height: 0.1,
                      ),
                      title: Text("Day".toUpperCase(),
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).accentColor)),
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
                            color: Theme.of(context).accentColor)),
                  ),
                  ListTile(
                    leading: Icon(Icons.text_snippet_outlined),
                    title: Text(widget.daynote.note,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 16),),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          OutlinedButton.icon(
                            icon: Icon(Icons.delete_outline_outlined, color: Theme.of(context).accentColor),
                            label: Text("Delete",style: TextStyle( color: Theme.of(context).accentColor),),
                            onPressed: () {
                              Navigator.of(context).pop();
                              showAlertDialogOkDelete(context);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                            ),
                          ),
                          const SizedBox(width: 50,),
                          OutlinedButton.icon(
                            icon: Icon(Icons.edit_outlined, color: Theme.of(context).accentColor),
                            label: Text("Edit",style: TextStyle( color: Theme.of(context).accentColor),),
                            onPressed: () {
                              Navigator.of(context).pop();
                                  Navigator.push(
                                      context,
                                       MaterialPageRoute<void>(
                                         builder: (BuildContext context) => EditNote(dayNoteEdit: widget.daynote),
                                        fullscreenDialog: true,
                                       )).then((value) => widget.refreshHome());
                            },
                            style: ElevatedButton.styleFrom(
                              //side: BorderSide(width: 2.0, color: Colors.blue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.calendar_today_outlined),
      title: Text(widget.daynote.day,
          textAlign: TextAlign.justify,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16)),
      onTap: openBottomMenu,
    );
  }
}

