import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/models/notes.dart';
import 'package:qdfitness/screens/home/noteslist.dart';
import 'package:qdfitness/services/database.dart';
import 'package:qdfitness/shared/shared.dart';

class Diary extends StatefulWidget {
  @override
  _DiaryState createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {
  bool food = true;
  bool thought = true;
  bool exercise = true;

  List<String> notetypes = ["food", "thought", "exercise"];

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
                  image: AssetImage("assets/images/backg2.png"),
                  fit: BoxFit.cover)),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      icon: Icon(FontAwesomeIcons.utensils),
                      color: food ? apptheme.c1 : apptheme.c1l,
                      onPressed: () {
                        setState(() {
                          food = !food;
                          print(food);
                          if (notetypes.contains("food")) {
                            notetypes.remove("food");
                          } else {
                            notetypes.add("food");
                          }
                        });
                      }),
                  IconButton(
                      icon: Icon(FontAwesomeIcons.dumbbell),
                      color: exercise ? apptheme.c2 : apptheme.c2l,
                      onPressed: () {
                        setState(() {
                          exercise = !exercise;
                          print(exercise);
                          if (notetypes.contains("exercise")) {
                            notetypes.remove("exercise");
                          } else {
                            notetypes.add("exercise");
                          }
                        });
                      }),
                  IconButton(
                      icon: Icon(FontAwesomeIcons.featherAlt),
                      color: thought ? apptheme.c3 : apptheme.c3l,
                      onPressed: () {
                        setState(() {
                          thought = !thought;
                          print(thought);
                          if (notetypes.contains("thought")) {
                            notetypes.remove("thought");
                          } else {
                            notetypes.add("thought");
                          }
                        });
                      }),
                ],
              ),
            ),
            Expanded(child: NotesList(notetypes: notetypes)),
          ],
        )
      ]),
    );
  }
}
