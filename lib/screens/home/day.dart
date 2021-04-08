import 'package:flutter/material.dart';
import 'package:qdfitness/models/notes.dart';
import 'package:qdfitness/screens/home/notetile.dart';

class DayTile extends StatelessWidget {
  final List<Note> notes;
  final String day;
  DayTile({this.notes, this.day});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            return NoteTile(note: notes[index]);
          }),
    );
  }
}
