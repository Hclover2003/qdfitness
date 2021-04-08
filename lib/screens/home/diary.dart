import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/models/notes.dart';
import 'package:qdfitness/screens/home/noteslist.dart';
import 'package:qdfitness/services/database.dart';

class Diary extends StatefulWidget {
  @override
  _DiaryState createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    return StreamProvider<List<Note>>.value(
      initialData: [
        Note(note: "loading notes", createdat: Timestamp.now(), type: "thought")
      ],
      value: DatabaseService(uid: user.uid).notes,
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/9.png"), fit: BoxFit.cover)),
        ),
        NotesList()
      ]),
    );
  }
}
