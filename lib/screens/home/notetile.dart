import 'package:flutter/material.dart';
import 'package:qdfitness/models/notes.dart';
import 'package:qdfitness/shared/shared.dart';
import 'package:intl/intl.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  NoteTile({this.note});

  @override
  Widget build(BuildContext context) {
    return (note.time == null)
        ? SizedBox(
            height: 10,
          )
        : Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
              child: ListTile(
                  trailing: Text((note.calories == null)
                      ? ''
                      : note.calories.toString() + " cal"),
                  leading: CircleAvatar(
                    radius: 25.0,
                    backgroundColor: (note.type == 'food')
                        ? apptheme.c1l
                        : (note.type == 'exercise'
                            ? apptheme.c2l
                            : apptheme.c3l),
                  ),
                  title: Text(note.note),
                  subtitle: Text(DateFormat.MMMd()
                      .add_jm()
                      .format(note.time.toDate())
                      .toString())),
            ),
          );
  }
}
