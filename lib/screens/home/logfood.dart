import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/models/food.dart';
import 'package:qdfitness/screens/home/foodchoices.dart';
import 'package:qdfitness/services/database.dart';
import 'package:qdfitness/shared/constantfns.dart';

class LogFood extends StatefulWidget {
  //meal and group constants
  final List<String> meals = ['breakfast', 'lunch', 'dinner', 'snacks'];
  final List<String> foodGroups = [
    'recent',
    'grain',
    'fruit',
    'veg',
    'protein',
    'dairy',
    'other'
  ];

  @override
  _LogFoodState createState() => _LogFoodState();
}

class _LogFoodState extends State<LogFood> {
  //initialize selected as breakfast and grain
  String selectedMeal = "breakfast";
  String selectedGroup = "recent";
  DailySummary todaysummary;

  List<FoodLog> items = [];
  int tmpCals = 0;
  
  List<bool> _selections = [false, false, false];

//add new food log to top of list
  void addFood(FoodLog food) {
    setState(() {
      items.insert(0, food);
      tmpCals += food.calories * food.num;
    });
  }

//add/minus/clear food num & update tmpcals
  void editFoodNum(String food, String type) {
    var tmpfood = items.firstWhere((element) => element.name == food);
    //add to existing food num, add to tmpcals
    if (type == "add") {
      setState(() {
        tmpfood.num += 1;
        tmpCals += tmpfood.calories;
      });
      //remove food, or subtract one from tmpcals
    } else if (type == "subtract") {
      setState(() {
        if (tmpfood.num == 1) {
          items.remove(tmpfood);
        } else {
          tmpfood.num -= 1;
        }
        tmpCals -= tmpfood.calories;
      });
      //clear food, subtract all from tmpcals
    } else if (type == "clear") {
      setState(() {
        items.remove(tmpfood);
        tmpCals -= (tmpfood.calories * tmpfood.num);
      });
    } else {
      print("not a valid view for editnum");
    }
  }

//delete all unsaved entries, reset tmpcals
  void clearAllSelected() {
    setState(() {
      items = [];
      tmpCals = 0;
    });
  }
//remove the element from items for this session (since it is now saved)
  void saveItem(FoodLog food) {
    setState(() {
      items.removeWhere((element) => element.name == food.name);
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


//gets a stream of foodlogs
    return StreamProvider<List<FoodLog>>.value(
        initialData: [],
        value: _db.foodlogs,
        child: Column(
          children: [
            //calorie number
            Container(
              color: Theme.of(context).backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  Text(
                    "/1500",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    (todaysummary.food + tmpCals).toString() + " cal",         
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  //expand icon
                  IconButton(
                      icon: Icon(Icons.zoom_in),
                      onPressed: () {
                        // var myModel = Provider.of<List<FoodLog>>(context, listen: false);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => Dialog(
                                insetPadding: EdgeInsets.fromLTRB(20, 20, 20, 100),
                                child: Column(
                                  children: [
                                    Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Text(
                                        (todaysummary.food + tmpCals).toString() + 
                                        " cals",
                                        style:
                                            Theme.of(context).textTheme.headline4,
                                      ),
                                    )),
                                    ToggleButtons(
                                      children: [
                                        Icon(Icons.cake),
                                        Icon(Icons.alarm),
                                        Icon(Icons.label)
                                      ],
                                      isSelected: _selections,
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: SizedBox(
                                          child: Align(
                                        alignment: Alignment.topCenter,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: items.length,
                                            itemBuilder: (context, i) {
                                              var allItems = items;
                                              return ListTile(
                                                tileColor: allItems[i].saved
                                                    ? Colors.red[100]
                                                    : Colors.blue[100],
                                                leading: Text(
                                                    allItems[i].num.toString() + "x"),
                                                title: Center(
                                                    child: Text(allItems[i].name +
                                                        DateFormat(
                                                                'yyyy-MM-dd hh:mm')
                                                            .format(allItems[i]
                                                                .createdat
                                                                .toDate())
                                                            .toString())),
                                                trailing: Text((allItems[i].calories *
                                                            items[i].num)
                                                        .toString() +
                                                    " cal"),
                                              );
                                            }),
                                      )),
                                    ),
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Exit'),
                                        child: Text('Exit'))
                                  ],
                                ),
                              ));})
                ]),
              ),
            ),
            //menu
            Menu(
                items: items,
                clearAllSelected: clearAllSelected,
                saveItem: saveItem,
                todaySummary: todaysummary,),
            //meal
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              for (var i in widget.meals)
                Expanded(
                    child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedMeal = i;
                          });
                        },
                        child: Container(
                          color: !(selectedMeal == i)
                              ? Color.fromRGBO(59, 65, 79, 1)
                              : Colors.white,
                          height: 50,
                          child: Center(
                            child: Text(
                              i,
                              style: TextStyle(
                                  fontWeight: (selectedMeal == i)
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: !(selectedMeal == i)
                                      ? Colors.white
                                      : Color.fromRGBO(59, 65, 79, 1)),
                            ),
                          ),
                        )))
            ]),
            //food group
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              for (var i in widget.foodGroups)
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
            FoodChoices(
                addFood: addFood,
                editFoodNum: editFoodNum,
                selectedGroup: selectedGroup,
                selectedFoods:
                    items.where((element) => !element.saved).toList(),
                selectedMeal: selectedMeal),
          ],
        ));
  }
}

class Menu extends StatefulWidget {
  Menu({
    Key key,
    @required this.items,
    @required this.clearAllSelected,
    @required this.saveItem,
    @required this.todaySummary,

  }) : super(key: key);

  final List<FoodLog> items;
  final Function clearAllSelected;
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
    var foodlogs = Provider.of<List<FoodLog>>(context)
            .where((element) =>
                DateTime(
                    DateTime.parse(element.createdat.toDate().toString()).year,
                    DateTime.parse(element.createdat.toDate().toString()).month,
                    DateTime.parse(element.createdat.toDate().toString())
                        .day) ==
                DateTime(now.year, now.month, now.day))
            .toList() ??
        [];
    foodlogs.sort((a, b) => b.createdat.compareTo(a.createdat));

    return 
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.fromLTRB(8,0,8,0),
                child: Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                            itemCount: widget.items.length + foodlogs.length,
                            itemBuilder: (context, i) {
                              var allItems = widget.items.isNotEmpty
                                  ? [...widget.items, ...foodlogs]
                                  : foodlogs;
                              return Dismissible(
                                  key: UniqueKey(),
                                  onDismissed: (direction) async {
                                    if (direction == DismissDirection.startToEnd) {
                                      var item = allItems[i];
                                      print(item.id);
                                      _db.summariesCollection.doc(user.uid).collection('userdailysummaries').doc(widget.todaySummary.id).update({
                                    'food': FieldValue.increment(-1*item.num*item.calories)
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
                                  child: FoodLogTile(
                                    item: allItems[i],
                                  ));
                            })),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          widget.clearAllSelected();
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
                              var saveFoodLogs = []..addAll(widget.items);
                              var foodtotal = 0;
                              for (FoodLog foodlog in saveFoodLogs) {
                                widget.saveItem(foodlog);
                                _db.foodLogCollection
                                    .doc(user.uid)
                                    .collection("userfoodlogs")
                                    .add({
                                  'name': foodlog.name,
                                  'createdat': Timestamp.now(),
                                  'num': foodlog.num,
                                  'meal': foodlog.meal,
                                  'unit': foodlog.unit,
                                  'calories': foodlog.calories
                                });
                                foodtotal +=(foodlog.num*foodlog.calories);
                              }
                              _db.summariesCollection.doc(user.uid).collection('userdailysummaries').doc(widget.todaySummary.id).update({
                                'food': FieldValue.increment(foodtotal)
                              });
                              widget.clearAllSelected();                       
                              print(
                                  "...............................save success!...............................");
                              Fluttertoast.showToast(
                                  msg: "saved!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
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
                Container(height: 10,color: Theme.of(context).backgroundColor,)],
               
               ),
              ),
            );
                
    
    
  }
}

class FoodLogTile extends StatefulWidget {
  const FoodLogTile({
    Key key,
    @required this.item,
  }) : super(key: key);

  final FoodLog item;

  @override
  _FoodLogTileState createState() => _FoodLogTileState();
}

class _FoodLogTileState extends State<FoodLogTile> {
  bool isSelected = false;
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
      leading: Text(widget.item.num.toString() + "x"),
      title: Center(child: Text(widget.item.name)),
      trailing:
          Text((widget.item.calories * widget.item.num).toString() + " cal"),
    );
  }
}
