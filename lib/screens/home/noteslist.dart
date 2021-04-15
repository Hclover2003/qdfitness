import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/models/notes.dart';
import 'package:intl/intl.dart';
import 'package:qdfitness/screens/home/editnote.dart';
import 'package:qdfitness/screens/home/headingtile.dart';
import 'package:qdfitness/screens/home/notetile.dart';
import 'package:qdfitness/services/database.dart';

class NotesList extends StatefulWidget {
  final List<String> notetypes;
  NotesList({this.notetypes});

  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  @override
  Widget build(BuildContext context) {
    final userdata = Provider.of<UserData>(context);
    final DatabaseService _db = DatabaseService(uid: userdata.uid);

    //fetch notes from provider, sort by time, and create copy
    var notes = Provider.of<List<Note>>(context) ?? [];
    notes.sort((b, a) => a.time.compareTo(b.time));
    notes = notes.where((i) => widget.notetypes.contains(i.type)).toList();
    List<Note> notescopy = []..addAll(notes);

    //function to compare times of neighboring notes
    getNoteDate(Note note) {
      return DateFormat.yMd().format(note.time.toDate()).toString();
    }

    // //insert heading notes
    var headingnum = 0;
    for (var i = 0; i < notes.length; i += 1) {
      if (notes[i].time != null) {
        //the time of the entry
        final entrydate =
            DateFormat.MMMMEEEEd().format(notes[i].time.toDate()).toString();
        if (i == 0) {
          notescopy.insert(
              headingnum + i,
              Note(
                  note: entrydate,
                  type: "heading",
                  createdat: Timestamp.now(),
                  time: Timestamp.now()));
          headingnum += 1;
        } else if (getNoteDate(notes[i]) != getNoteDate(notes[i - 1])) {
          notescopy.insert(
              headingnum + i,
              Note(
                  note: entrydate,
                  type: "heading",
                  createdat: Timestamp.now(),
                  time: Timestamp.now()));
          headingnum += 1;
        }
      }
    }

    //show editnote bottomsheet
    void _showEditPanel(note) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return EditNote(note: note, uid: userdata.uid);
          });
    }

    return ListView.builder(
        itemCount: notescopy.length,
        itemBuilder: (context, index) {
          final note = notescopy[index];
          return (note.type == "heading")
              ? HeadingTile(
                  note: note,
                )
              : Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      await _db
                          .deleteNote(note.id)
                          .then((value) => print('success'));
                    }
                  },
                  confirmDismiss: (DismissDirection direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Confirm"),
                            content: Text(
                                "Are you sure you wish to delete this item?"),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: Text("DELETE")),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text("CANCEL"),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      _showEditPanel(note);
                      return false;
                    }
                  },
                  background: Container(
                    color: Colors.red,
                  ),
                  secondaryBackground: Container(color: Colors.green),
                  child: NoteTile(note: note));
        });
  }
}
