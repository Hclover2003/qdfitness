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
import 'dart:math';

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
  double selectedHours = 0.5;
  int selectedCalories = 0;
  double metvalue = 0;
  double weight = 55.6;

  ExerciseLog newExerciseLog;

  double _currentSliderValue = 0;
  int _currentIntValue = 30;

  Level _level = Level.light;

//update the new exerciselog info
  void updateExercise(Exercise exercise) {
    print(exercise.get(selectedLevel));
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(selectedHours.toString() ?? "null"),
                Text(selectedExercise ?? "null"),
                Text(selectedActivity != null
                    ? (weight *
                                selectedActivity.get(selectedLevel) *
                                selectedHours)
                            .toInt()
                            .toString() ??
                        "null"
                    : "nothing")
              ],
            ),
            //menu
            Menu(
              newExerciseLog: ExerciseLog(
                  hours: selectedHours,
                  name: selectedExercise,
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
                      flex: 4,
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
                            Radio<Level>(
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => selectedActivity == null
                                      ? Colors.white
                                      : selectedActivity.veryLight == 0
                                          ? Colors.blueGrey[300]
                                          : Colors.white),
                              focusColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                              value: Level.veryLight,
                              groupValue: _level,
                              onChanged: selectedActivity == null
                                  ? null
                                  : selectedActivity.veryLight == 0
                                      ? null
                                      : (Level level) {
                                          setState(() {
                                            _level = level;
                                            selectedLevel = "veryLight";
                                          });
                                        },
                            ),
                            Radio<Level>(
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => selectedActivity == null
                                      ? Colors.white
                                      : selectedActivity.light == 0
                                          ? Colors.blueGrey[300]
                                          : Colors.white),
                              focusColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                              value: Level.light,
                              groupValue: _level,
                              onChanged: selectedActivity == null
                                  ? null
                                  : selectedActivity.light == 0
                                      ? null
                                      : (Level level) {
                                          setState(() {
                                            _level = level;
                                            selectedLevel = "light";
                                          });
                                        },
                            ),
                            Radio<Level>(
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => selectedActivity == null
                                      ? Colors.white
                                      : selectedActivity.moderate == 0
                                          ? Colors.blueGrey[300]
                                          : Colors.white),
                              focusColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                              value: Level.moderate,
                              groupValue: _level,
                              onChanged: selectedActivity == null
                                  ? null
                                  : selectedActivity.moderate == 0
                                      ? null
                                      : (Level level) {
                                          setState(() {
                                            _level = level;
                                            selectedLevel = "moderate";
                                          });
                                        },
                            ),
                            Radio<Level>(
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => selectedActivity == null
                                      ? Colors.white
                                      : selectedActivity.intense == 0
                                          ? Colors.blueGrey[300]
                                          : Colors.white),
                              focusColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                              value: Level.intense,
                              groupValue: _level,
                              onChanged: selectedActivity == null
                                  ? null
                                  : selectedActivity.intense == 0
                                      ? null
                                      : (Level level) {
                                          setState(() {
                                            _level = level;
                                            selectedLevel = "intense";
                                          });
                                        },
                            ),
                            Radio<Level>(
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => selectedActivity == null
                                      ? Colors.white
                                      : selectedActivity.veryIntense == 0
                                          ? Colors.blueGrey[300]
                                          : Colors.white),
                              focusColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                              value: Level.veryIntense,
                              groupValue: _level,
                              onChanged: selectedActivity == null
                                  ? null
                                  : selectedActivity.veryIntense == 0
                                      ? null
                                      : (Level level) {
                                          setState(() {
                                            _level = level;
                                            selectedLevel = "veryIntense";
                                          });
                                        },
                            )
                          ],
                        ),
                        // child: SliderTheme(
                        //   data: SliderTheme.of(context).copyWith(
                        //     activeTrackColor: Colors.white.withOpacity(1),
                        //     inactiveTrackColor: Colors.white.withOpacity(.5),
                        //     trackHeight: 4.0,
                        //     thumbShape: CustomSliderThumbCircle(
                        //       thumbRadius: 48 * .4,
                        //       min: 240,
                        //       max: 740,
                        //     ),
                        //     overlayColor: Colors.white.withOpacity(.4),
                        //     //valueIndicatorColor: Colors.white,
                        //     activeTickMarkColor: Colors.white,
                        //     inactiveTickMarkColor: Colors.white.withOpacity(.7),
                        //   ),
                        //   child: Slider(
                        //       value: _currentSliderValue,
                        //       min: 0,
                        //       max: 3,
                        //       divisions: 3,
                        //       label: widget
                        //           .exerciseLevels[_currentSliderValue.toInt()],
                        //       onChanged: (double value) {
                        //         setState(() {
                        //           _currentSliderValue = value;
                        //         });
                        //       }),
                        // ),
                      ),
                    ),
                    // Flexible(
                    //     flex: 1,
                    //     child: Container(
                    //         height: 48,
                    //         color: const Color(0xFF0072ff),
                    //         child: TextFormField(
                    //             decoration:
                    //                 InputDecoration(border: InputBorder.none),
                    //             textAlign: TextAlign.right,
                    //             initialValue: _currentIntValue.toString(),
                    //             keyboardType: TextInputType.number,
                    //             style: TextStyle(
                    //                 color: Colors.white,
                    //                 fontWeight: FontWeight.bold,
                    //                 fontSize: 18)))),
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
                                    : selectedHours.toString() + " h",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            onPressed: () {
                              print(selectedHours);
                              var size = MediaQuery.of(context).size;
                              double height = 300;
                              var itemWidth = size.width / 2;
                              var itemHeight = (height - 50) / 2;
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height: height,
                                      color: Colors.blue,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 50,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                selectedHours < 1
                                                    ? (selectedHours * 60)
                                                            .toInt()
                                                            .toString() +
                                                        " min"
                                                    : selectedHours % 1 == 0
                                                        ? " ${selectedHours.floor()} h"
                                                        : " ${selectedHours.floor()} h ${((selectedHours % 1) * 60).toInt()} min",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: GridView.count(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              crossAxisCount: 2,
                                              childAspectRatio:
                                                  itemWidth / itemHeight,
                                              children: [
                                                CircleHour(
                                                    updateHours: updateHours,
                                                    selectedHours:
                                                        selectedHours,
                                                    hours: 0.5),
                                                CircleHour(
                                                    updateHours: updateHours,
                                                    selectedHours:
                                                        selectedHours,
                                                    hours: 1),
                                                CircleHour(
                                                    updateHours: updateHours,
                                                    selectedHours:
                                                        selectedHours,
                                                    hours: 1.5),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      updateHours(2);
                                                    },
                                                    child: Container(
                                                        child: Center(
                                                            child: Padding(
                                                                padding: const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        10),
                                                                child: TextFormField(
                                                                    decoration: InputDecoration(
                                                                        border: InputBorder
                                                                            .none),
                                                                    textAlign: TextAlign
                                                                        .right,
                                                                    initialValue: _currentIntValue
                                                                        .toString(),
                                                                    keyboardType: TextInputType
                                                                        .number,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight: FontWeight
                                                                            .bold,
                                                                        fontSize:
                                                                            18)))),
                                                        decoration: BoxDecoration(
                                                            color: Colors.purple.withOpacity(0.6),
                                                            borderRadius: BorderRadius.all(Radius.circular(100)))),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
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
}

class CircleHour extends StatefulWidget {
  const CircleHour({
    Key key,
    @required this.selectedHours,
    @required this.hours,
    @required this.updateHours,
  }) : super(key: key);

  final double selectedHours;
  final double hours;
  final Function updateHours;

  @override
  _CircleHourState createState() => _CircleHourState();
}

class _CircleHourState extends State<CircleHour> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          widget.updateHours(widget.hours);
        },
        child: Container(
            child: Center(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                        widget.hours < 1
                            ? (widget.hours * 60).toInt().toString() + " min"
                            : widget.hours % 1 == 0
                                ? " ${widget.hours.floor()} h"
                                : " ${widget.hours.floor()} h ${((widget.hours % 1) * 60).toInt()} min",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)))),
            decoration: BoxDecoration(
                color: widget.selectedHours == widget.hours
                    ? Colors.black.withOpacity(0.2)
                    : Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.all(Radius.circular(100)))),
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
                              _db.deleteFoodLog(item.id);
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
                      "clear all",
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

  @override
  void initState() {
    super.initState();
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
      leading: Text(widget.item.hours.toString() + "h"),
      title: Center(child: Text(widget.item.name)),
      trailing: Text(widget.item.calories.toString() + " cal"),
    );
  }
}
