import 'package:day_study/db/dayNoteDao.dart';
import 'package:flutter/material.dart';

class DayCard extends StatefulWidget {
  @override
  _DayCardState createState() => _DayCardState();

  int id;
  String day;
  String note;
  Function() refreshHome;

  DayCard({Key? key, required this.day, required this.id, required this.note,required this.refreshHome})
      : super(key: key);
}

class _DayCardState extends State<DayCard> {

  Future<void> _delete() async {
    final dbDayNotes = DayNoteDao.instance;
    final deleted = await dbDayNotes.delete(widget.id);
    widget.refreshHome();
  }

  showAlertDialogOkDelete(BuildContext context) {
    Widget okButton = TextButton(
      child: Text(
        "Yes",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        _delete();
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
                      leading: Icon(Icons.calendar_today_outlined),
                      title: Text(
                        widget.day,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_outline_outlined),
                        onPressed: () {
                          showAlertDialogOkDelete(context);
                        },
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.text_snippet_outlined),
                    title: Text(widget.note,style: TextStyle(
                        fontSize: 16),),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onTap: openBottomMenu,
          child: Center(
              child: Text(widget.day,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16))),
        ));
  }
}
