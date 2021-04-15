import 'package:flutter/material.dart';
import 'package:qdfitness/models/notes.dart';
import 'package:qdfitness/shared/shared.dart';

class HeadingTile extends StatelessWidget {
  final Note note;
  HeadingTile({this.note});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          color: apptheme.c1,
          child: ListTile(
            title: Center(
                child: Text(
              note.note,
              style: TextStyle(color: Colors.white),
            )),
          ),
        ));
  }
}
