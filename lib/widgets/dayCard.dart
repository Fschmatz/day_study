import 'package:flutter/material.dart';

class DayCard extends StatefulWidget {
  @override
  _DayCardState createState() => _DayCardState();

  int id;
  String day;

  DayCard({Key? key, required this.day, required this.id}) : super(key: key);
}

class _DayCardState extends State<DayCard> {

  @override
  Widget build(BuildContext context) {

    return Card(
        color: Color(0xFF3F8CCB),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text(widget.day,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600,fontSize: 16)
          )),
        ));
  }
}
