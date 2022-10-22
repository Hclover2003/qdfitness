import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/models/exercise.dart';
import 'package:qdfitness/models/food.dart';
import 'package:qdfitness/screens/home/exercisechoices.dart';
import 'package:qdfitness/services/database.dart';
import 'package:qdfitness/shared/constantfns.dart';

class LogExercise extends StatefulWidget {
  //meal and group constants
  final List<String> exerciseGroups = [
    'recent',
    'move',
    'sport',
    'stretch',
    'other',
    'custom'
  ];

  final Map<String, String> exerciseLevels = {
    "veryLight": "very light",
    "light": "light",
    "moderate": "moderate",
    "intense": "intense",
    "veryIntense": "very intense"
  };

  @override
  _LogExerciseState createState() => _LogExerciseState();
}

enum Level { veryLight, light, moderate, intense, veryIntense }

class _LogExerciseState extends State<LogExercise> {
  DailySummary todaysummary;
  int tmpCals = 0;

  //initialize selected as light and recent
  String selectedGroup = "recent";
  String selectedLevel = "moderate";
  String selectedExercise;
  Exercise selectedActivity;

  int selectedCalories = 0;
  double selectedHours = 0.5;
  double weight = 55.6;

  Level _level = Level.light;

//update the new exerciselog info
  void updateExercise(Exercise exercise) {
    double metval = exercise.get(selectedLevel);
    if (metval == 0) {
      setState(() {
        selectedLevel = "moderate";
        _level = Level.moderate;
      });
    }
    setState(() {
      selectedExercise = exercise.name;
      selectedActivity = exercise;
      selectedCalories =
          (weight * exercise.get(selectedLevel) * selectedHours).toInt();
    });
  }

//save exercise, reset tmpcals
  void saveItem() {
    setState(() {
      selectedExercise = null;
      tmpCals = 0;
    });
  }

  void updateHours(double hours) {
    setState(() {
      selectedHours = hours;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    final DatabaseService _db = DatabaseService(uid: user.uid);
    var dailysummaries = Provider.of<List<DailySummary>>(context);
    setState(() {
      todaysummary = getTodaySummary(dailysummaries);
    });

//gets a stream of exerciselogs
    return StreamProvider<List<ExerciseLog>>.value(
        initialData: [],
        value: _db.exerciselogs,
        child: Column(
          children: [
            //calorie number
            Container(
              color: Theme.of(context).backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "/1500",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        (todaysummary.exercise + tmpCals).toString() + " cal",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      //expand icon
                      IconButton(
                          icon: Icon(Icons.zoom_in),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => Dialog(
                                      insetPadding:
                                          EdgeInsets.fromLTRB(20, 20, 20, 100),
                                      child: Column(
                                        children: [
                                          Center(
                                              child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Text(
                                              (todaysummary.food + tmpCals)
                                                      .toString() +
                                                  " cals",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4,
                                            ),
                                          )),
                                          ToggleButtons(
                                            children: [
                                              Icon(Icons.cake),
                                              Icon(Icons.alarm),
                                              Icon(Icons.label)
                                            ],
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: SizedBox(
                                                child: Align(
                                              alignment: Alignment.topCenter,
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: 0,
                                                  itemBuilder: (context, i) {
                                                    var allItems = [];
                                                    return ListTile(
                                                      tileColor: allItems[i]
                                                              .saved
                                                          ? Colors.red[100]
                                                          : Colors.blue[100],
                                                      leading: Text(allItems[i]
                                                              .num
                                                              .toString() +
                                                          "x"),
                                                      title: Center(
                                                          child: Text(allItems[
                                                                      i]
                                                                  .name +
                                                              DateFormat(
                                                                      'yyyy-MM-dd hh:mm')
                                                                  .format(allItems[
                                                                          i]
                                                                      .createdat
                                                                      .toDate())
                                                                  .toString())),
                                                      trailing: Text(
                                                          (allItems[i].calories *
                                                                      allItems[
                                                                              i]
                                                                          .num)
                                                                  .toString() +
                                                              " cal"),
                                                    );
                                                  }),
                                            )),
                                          ),
                                          TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'Exit'),
                                              child: Text('Exit'))
                                        ],
                                      ),
                                    ));
                          })
                    ]),
              ),
            ),

            //menu
            Menu(
              newExerciseLog: ExerciseLog(
                  hours: selectedHours,
                  name: selectedExercise,
                  level: selectedLevel,
                  calories: selectedActivity != null
                      ? (weight *
                              selectedActivity.get(selectedLevel) *
                              selectedHours)
                          .toInt()
                      : null,
                  saved: false),
              saveItem: saveItem,
              todaySummary: todaysummary,
            ),
            //choose exercise level and number of hours
            Container(
              color: Theme.of(context).backgroundColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.5),
                child: Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: new LinearGradient(
                              colors: [
                                const Color(0xFF00c6ff),
                                const Color(0xFF0072ff),
                              ],
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(1.0, 1.00),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RadioLevel("veryLight", Level.veryLight),
                            RadioLevel("light", Level.light),
                            RadioLevel("moderate", Level.moderate),
                            RadioLevel("intense", Level.intense),
                            RadioLevel("veryIntense", Level.veryIntense),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        height: 48,
                        color: const Color(0xFF0072ff),
                        child: Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            child: Text(
                                selectedHours < 1
                                    ? (selectedHours * 60).toInt().toString() +
                                        " min"
                                    : selectedHours % 1 == 0
                                        ? " ${selectedHours.floor()} h"
                                        : " ${selectedHours.floor()} h ${((selectedHours % 1) * 60).toInt()} min",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return BottomSheetHours(
                                      updateHours: updateHours,
                                    );
                                  });
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              for (var i in widget.exerciseGroups)
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGroup = i;
                    });
                  },
                  child: Container(
                    color: Colors.white,
                    height: 50,
                    child: Center(
                      child: Text(
                        i,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(59, 65, 79, 1),
                            fontWeight: (selectedGroup == i)
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    ),
                  ),
                ))
            ]),
            //food choices
            ExerciseChoices(
                updateExercise: updateExercise,
                selectedGroup: selectedGroup,
                selectedExercise: selectedExercise,
                selectedActivity: selectedActivity,
                selectedLevel: selectedLevel,
                selectedHours: selectedHours)
          ],
        ));
  }

  Tooltip RadioLevel(String leveltxt, Level level) {
    return Tooltip(
      message: leveltxt,
      child: Radio<Level>(
        fillColor:
            MaterialStateColor.resolveWith((states) => selectedActivity == null
                ? Colors.white
                : selectedActivity.get(leveltxt) == 0
                    ? Colors.blueGrey[300]
                    : Colors.white),
        focusColor: MaterialStateColor.resolveWith((states) => Colors.white),
        value: level,
        groupValue: _level,
        onChanged: selectedActivity == null
            ? null
            : selectedActivity.get(leveltxt) == 0
                ? null
                : (Level level) {
                    setState(() {
                      _level = level;
                      selectedLevel = leveltxt;
                    });
                  },
      ),
    );
  }
}

class Menu extends StatefulWidget {
  Menu({
    Key key,
    @required this.newExerciseLog,
    @required this.saveItem,
    @required this.todaySummary,
  }) : super(key: key);

  final ExerciseLog newExerciseLog;
  final Function saveItem;
  final DailySummary todaySummary;

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    final DatabaseService _db = DatabaseService(uid: user.uid);
    var now = DateTime.now();
    var exerciselogs = Provider.of<List<ExerciseLog>>(context)
            .where((element) =>
                DateTime(
                    DateTime.parse(element.createdat.toDate().toString()).year,
                    DateTime.parse(element.createdat.toDate().toString()).month,
                    DateTime.parse(element.createdat.toDate().toString())
                        .day) ==
                DateTime(now.year, now.month, now.day))
            .toList() ??
        [];
    exerciselogs.sort((a, b) => b.createdat.compareTo(a.createdat));

    return Expanded(
      flex: 5,
      child: Padding(
        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: widget.newExerciseLog.name == null
                        ? exerciselogs.length
                        : exerciselogs.length + 1,
                    itemBuilder: (context, i) {
                      var allItems = widget.newExerciseLog.name == null
                          ? exerciselogs
                          : [widget.newExerciseLog, ...exerciselogs];
                      return Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              var item = allItems[i];
                              print(item.id);
                              _db.summariesCollection
                                  .doc(user.uid)
                                  .collection('userdailysummaries')
                                  .doc(widget.todaySummary.id)
                                  .update({
                                'exercise':
                                    FieldValue.increment(-1 * item.calories)
                              });
                              _db.deleteExerciseLog(item.id);
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
                              return false;
                            }
                          },
                          background: Container(
                            color: Colors.red,
                          ),
                          secondaryBackground: Container(color: Colors.green),
                          child: ExerciseLogTile(
                            item: allItems[i],
                          ));
                    })),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      widget.saveItem();
                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(15)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        )),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.red.shade300)),
                    child: Text(
                      "clear",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                //view selected
                Expanded(
                    child: TextButton(
                        onPressed: () async {
                          if (widget.newExerciseLog.name != null) {
                            _db.exerciseLogCollection
                                .doc(user.uid)
                                .collection("userexerciselogs")
                                .add({
                              'name': widget.newExerciseLog.name,
                              'createdat': Timestamp.now(),
                              'hours': widget.newExerciseLog.hours,
                              'level': widget.newExerciseLog.level,
                              'calories': widget.newExerciseLog.calories
                            });

                            _db.summariesCollection
                                .doc(user.uid)
                                .collection('userdailysummaries')
                                .doc(widget.todaySummary.id)
                                .update({
                              'exercise': FieldValue.increment(
                                  widget.newExerciseLog.calories)
                            });
                            widget.saveItem();
                            print(
                                "...............................save success!...............................");
                            Fluttertoast.showToast(
                                msg: "saved!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.all(15)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            )),
                            backgroundColor: MaterialStateProperty.all(
                                Colors.blue.shade200)),
                        child: Text(
                          "save",
                          style: TextStyle(color: Colors.white),
                        )))
              ],
            ),
            Container(
              height: 10,
              color: Theme.of(context).backgroundColor,
            )
          ],
        ),
      ),
    );
  }
}

class ExerciseLogTile extends StatefulWidget {
  const ExerciseLogTile({
    Key key,
    @required this.item,
  }) : super(key: key);

  final ExerciseLog item;

  @override
  _ExerciseLogTileState createState() => _ExerciseLogTileState();
}

class _ExerciseLogTileState extends State<ExerciseLogTile> {
  Color mycolor;
  Color levelcolor;
  String mode = "light";

  @override
  void initState() {
    super.initState();
    setState(() {
      switch (widget.item.level) {
        case 'veryLight':
          levelcolor = Colors.blue[200];
          break;
        case 'light':
          levelcolor = Colors.blue[300];
          break;
        case 'moderate':
          levelcolor = Colors.blue[500];
          mode = "dark";
          break;
        case 'intense':
          levelcolor = Colors.blue[700];
          mode = "dark";
          break;
        case 'veryIntense':
          levelcolor = Colors.blue[900];
          mode = "dark";
          break;
      }
    });
    if (widget.item.saved) {
      setState(() {
        mycolor = Colors.white;
      });
    } else {
      setState(() {
        mycolor = Colors.blue[100];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: mycolor,
      leading: Container(
          height: 50,
          width: 80,
          color: levelcolor,
          child: Align(
              alignment: Alignment.center,
              child: Text(
                widget.item.hours < 1
                    ? (widget.item.hours * 60).toInt().toString() + " min"
                    : widget.item.hours % 1 == 0
                        ? " ${widget.item.hours.floor()} h"
                        : " ${widget.item.hours.floor()} h ${((widget.item.hours % 1) * 60).toInt()} min",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: mode == "light" ? Colors.black : Colors.white),
              ))),
      title: Center(child: Text(widget.item.name)),
      trailing: Text(widget.item.calories.toString() + " cal"),
    );
  }
}

class BottomSheetHours extends StatefulWidget {
  const BottomSheetHours({
    Key key,
    @required this.updateHours,
  }) : super(key: key);

  final Function updateHours;
  @override
  _BottomSheetHoursState createState() => _BottomSheetHoursState();
}

List<double> hourslist = [0.25, 0.5, 0.75, 1, 1.5, 1.75, 2];

class _BottomSheetHoursState extends State<BottomSheetHours> {
  double _hourschoice = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        color: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Wrap(spacing: 10, runSpacing: 4, children: [
              for (var i in hourslist)
                createChoiceChip(index: i, label: i.toString())
            ])
          ],
        ));
  }

  Widget createChoiceChip({double index, String label}) {
    return ChoiceChip(
      label: Text(
          index < 1
              ? (index * 60).toInt().toString() + " min"
              : index % 1 == 0
                  ? " ${index.floor()} h"
                  : " ${index.floor()} h ${((index % 1) * 60).toInt()} min",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
      labelStyle:
          TextStyle(color: Colors.black87, fontFamily: 'Futura', fontSize: 13),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.grey[600].withOpacity(0.7),
      disabledColor: Colors.black,
      selected: _hourschoice == index,
      onSelected: (bool selected) {
        setState(() {
          _hourschoice = index;
        });
        widget.updateHours(index);
      },
    );
  }
}
