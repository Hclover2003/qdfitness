import 'package:flutter/material.dart';
import 'package:qdfitness/models/notes.dart';
import 'package:qdfitness/shared/shared.dart';
import 'package:intl/intl.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  NoteTile({this.note});

  @override
  Widget build(BuildContext context) {
    final createdat = DateFormat.MMMd()
        .add_jm()
        .format(DateTime.fromMillisecondsSinceEpoch(
            note.createdat.millisecondsSinceEpoch))
        .toString();
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundColor: (note.type == 'food')
                  ? myPink
                  : (note.type == 'exercise' ? myLBlue : myLYellow),
            ),
            title: Text(note.note),
            subtitle: Text(createdat)),
      ),
    );
  }
}
