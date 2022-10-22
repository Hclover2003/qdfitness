import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/models/exercise.dart';
import 'dart:io' as io;

class CircleItemExercise extends StatefulWidget {
  const CircleItemExercise({
    Key key,
    @required this.exercise,
    @required this.selectedExercise,
    @required this.selectedLevel,
    @required this.selectedActivity,
    @required this.updateExercise,
  }) : super(key: key);

  final Exercise exercise;
  final String selectedExercise;
  final String selectedLevel;
  final Exercise selectedActivity;
  final Function updateExercise;

  @override
  _CircleItemExerciseState createState() => _CircleItemExerciseState();
}

class _CircleItemExerciseState extends State<CircleItemExercise> {
  String label;
  double weight = 56.0;

  @override
  void initState() {
    super.initState();
    label = widget.exercise.name;
  }

  String getImage(String name) {
    String path = 'assets/exerciseimg/$name.jpg';
    if (io.File(path).existsSync()) {
      return path;
    } else {
      return "assets/exerciseimg/bowling.jpg";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(14.0),
        child: GestureDetector(
          onTap: () {
            widget.updateExercise(widget.exercise);
          },
          child: Tooltip(
            message:
                "${widget.exercise.name} : ${(widget.exercise.get(widget.selectedLevel) * weight).toInt()} cal/h ",
            child: Container(
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: (widget.exercise.name == widget.selectedExercise)
                      ? Icon(Icons.check, color: Colors.white,)
                      : Text(widget.exercise.name,
                          style: TextStyle(
                            color: Colors.white,
                          )),
                )),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: widget.selectedExercise == widget.exercise.name
                              ? ColorFilter.mode(Colors.black.withOpacity(0.2),
                                  BlendMode.darken)
                              : ColorFilter.mode(Colors.black.withOpacity(0.6),
                                  BlendMode.darken),
                      image: AssetImage("assets/exerciseimg/${widget.exercise.name}.jpg")),
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                )),
          ),
        ));
  }
}
