import 'package:day_study/db/dayNoteDao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NewNote extends StatefulWidget {

  @override
  _NewNoteState createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {

  final dbDayNotes = DayNoteDao.instance;
  late DateTime dateSelected;

  TextEditingController customControllerNote = TextEditingController();


  @override
  void initState() {
    super.initState();
    dateSelected = DateTime.now();
  }

  getSelectedDateFormatted() {
    return DateFormat('dd/MM').format(dateSelected);
  }

  void _saveNote() async {
    Map<String, dynamic> row = {
      DayNoteDao.columnNote: customControllerNote.text,
      DayNoteDao.columnDay: getSelectedDateFormatted().toString(),
    };
    final id = await dbDayNotes.insert(row);
    print('id = $id');
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

  chooseDate() async {
    DateTime? data = await showDatePicker(
        context: context,
        initialDate: dateSelected,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));

    if (data != null) {
      setState(() {
        dateSelected = data;
      });
    }
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
                    _saveNote();
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
                    onTap: () {
                      chooseDate();
                    },
                    contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    leading: Icon(Icons.date_range_outlined),
                    title: Text(getSelectedDateFormatted().toString()),
                  ),
                  const SizedBox(height: 10,),
                  TextField(
                    autofocus: true,
                    minLines: 1,
                    maxLines: 12,
                    maxLength: 2000,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    controller: customControllerNote,
                    decoration: InputDecoration(
                      focusColor: Theme.of(context).accentColor,
                        prefixIcon: Icon(Icons.text_snippet_outlined, size: 20,color: Theme.of(context)
                            .textTheme
                            .headline6!
                            .color!
                            ,),
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
