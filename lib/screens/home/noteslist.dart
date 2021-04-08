import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qdfitness/models/notes.dart';
import 'package:qdfitness/screens/home/day.dart';
import 'package:intl/intl.dart';
import 'package:qdfitness/screens/home/notetile.dart';

class NotesList extends StatefulWidget {
  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  @override
  Widget build(BuildContext context) {
    final notes = Provider.of<List<Note>>(context) ?? [];
    notes.sort((b, a) => a.createdat.compareTo(b.createdat));
    final Map<String, List<Note>> mymap = new Map();

    for (var note in notes) {
      var notedate = DateFormat.yMd().format(
          DateTime.fromMillisecondsSinceEpoch(
              note.createdat.millisecondsSinceEpoch));
      if (mymap.containsKey(notedate)) {
        mymap[notedate].add(note);
      } else {
        mymap[notedate] = [note];
      }
    }
    return ListView.builder(
        itemCount: mymap.keys.toList().length,
        itemBuilder: (context, index) {
          return NoteTile(note: notes[index]);
        });

    // for (var notelist in mymap.values.toList()) {
    //   return ListView.builder(
    //       itemCount: mymap.keys.toList().length,
    //       itemBuilder: (context, index) {
    //         return DayTile(
    //           notes: notelist,
    //           day: "3/5",
    //         );
    // return ListView.builder(
    //     itemCount: mymap.keys.toList().length,
    //     itemBuilder: (context, index) {
    //       return NoteTile(note: notes[index]);
    //     });
  }
}
