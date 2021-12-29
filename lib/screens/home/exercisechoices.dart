import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/models/exercise.dart';
import 'package:qdfitness/screens/home/circleitemexercise.dart';
import 'package:qdfitness/services/database.dart';

class ExerciseChoices extends StatelessWidget {
  const ExerciseChoices({
    Key key,
    @required this.selectedGroup,
    @required this.selectedLevel,
    @required this.selectedExercise,
    @required this.selectedHours,
    @required this.updateExercise,
  }) : super(key: key);

  final String selectedGroup;
  final String selectedLevel;
  final String selectedExercise;
  final double selectedHours;
  final Function updateExercise;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    final DatabaseService _db = DatabaseService(uid: user.uid);
    var exerciselogs = Provider.of<List<ExerciseLog>>(context);

    //get most recent exercises
    Map<String, ExerciseLog> mp = {};
    for (var item in exerciselogs) {
      if (!mp.containsKey(item.name)) {
        mp[item.name] = item;
      }
    }
    var filteredList = mp.values.toList();
    filteredList.sort((a, b) => b.createdat.compareTo(a.createdat));
    var recentexerciselogs = filteredList.sublist(
        0, filteredList.length > 12 ? 12 : filteredList.length);

    return FutureBuilder<QuerySnapshot>(
      future: _db.exerciseCollection.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (!snapshot.hasData) {
          return SizedBox(
            height: 0.25 * MediaQuery.of(context).size.height,
          );
        }
        List<Exercise> exercises = snapshot.data.docs
            .map((doc) => Exercise(
                  name: doc['name'],
                  id: doc.id,
                  group: doc['group'],
                  veryLight: doc['veryLight'].toDouble(),
                  light: doc['light'].toDouble(),
                  moderate: doc['moderate'].toDouble(),
                  intense: doc['intense'].toDouble(),
                  veryIntense: doc['veryIntense'].toDouble(),
                ))
            .toList();

        exercises.sort((a, b) => a.name.compareTo(b.name));

        return Expanded(
          flex: 4,
          child: Container(
            color: Colors.white,
            child: GridView.count(crossAxisCount: 3, children: [
              if (selectedGroup == 'recent')
                for (var exercise in recentexerciselogs)
                  CircleItemExercise(
                      exercise: exercises.firstWhere(
                          (element) => element.name == exercise.name),
                      updateExercise: updateExercise,
                      selectedExercise: selectedExercise,
                      selectedLevel: selectedLevel),
              for (var exercise in exercises
                  .where((element) => (element.group == selectedGroup)))
                CircleItemExercise(
                    exercise: exercises
                        .firstWhere((element) => element.name == exercise.name),
                    updateExercise: updateExercise,
                    selectedExercise: selectedExercise,
                    selectedLevel: selectedLevel),
            ]),
          ),
        );
      },
    );
  }
}
