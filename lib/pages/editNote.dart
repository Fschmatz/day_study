import 'package:day_study/classes/dayNote.dart';
import 'package:day_study/db/dayNoteDao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class EditNote extends StatefulWidget {

  DayNote dayNoteEdit;

  EditNote({Key? key, required this.dayNoteEdit})
      : super(key: key);

  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {

  final dbDayNotes = DayNoteDao.instance;

  TextEditingController customControllerNote = TextEditingController();

  @override
  void initState() {
    super.initState();
    customControllerNote.text = widget.dayNoteEdit.note;
  }

  getCurrentDate() {
    return DateFormat('dd/MM').format(DateTime.now());
  }

  void _updateDayNote() async {
    Map<String, dynamic> row = {
      DayNoteDao.columnId: widget.dayNoteEdit.id,
      DayNoteDao.columnDay: widget.dayNoteEdit.day,
      DayNoteDao.columnNote: customControllerNote.text,
    };
    final update = await dbDayNotes.update(row);
  }


  String checkProblems() {
    String errors = "";
    if (customControllerNote.text.isEmpty) {
      errors += "Note is empty\n";
    }
    return errors;
  }

  showAlertDialogErrors(BuildContext context) {
    Widget okButton = TextButton(
      child: Text(
        "Ok",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      elevation: 3.0,
      title: Text(
        "Error",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: Text(
        checkProblems(),
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

    return Scaffold(
        appBar: AppBar(
          title: Text("New Note"),
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: IconButton(
                icon: Icon(Icons.save_outlined),
                tooltip: 'Save',
                onPressed: () {
                  if (checkProblems().isEmpty) {
                    _updateDayNote();
                    Navigator.of(context).pop();
                  } else {
                    showAlertDialogErrors(context);
                  }
                },
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    leading: Icon(Icons.calendar_today_outlined),
                    title: Text(getCurrentDate().toString()),
                  ),
                  const SizedBox(height: 10,),
                  TextField(
                    minLines: 1,
                    maxLines: 10,
                    maxLength: 1000,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    keyboardType: TextInputType.name,
                    controller: customControllerNote,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.text_snippet_outlined, size: 20,color: Theme.of(context)
                            .textTheme
                            .headline6!
                            .color!
                           ),
                        hintText: "Note",
                        helperText: "* Required",
                    ),
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ]
            )
        )
    );

  }
}
