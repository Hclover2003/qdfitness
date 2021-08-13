import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/models/food.dart';
import 'package:qdfitness/screens/home/foodchoices.dart';
import 'package:qdfitness/services/database.dart';

typedef void AddDelete(String id);

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
  ];

  @override
  _LogFoodState createState() => _LogFoodState();
}

class _LogFoodState extends State<LogFood> {
  //initialize selected as breakfast and grain
  String selectedMeal = "breakfast";
  String selectedGroup = "recent";

  List<FoodLog> items = [];
  List<bool> _selections = [false, false, false];
  List<String> itemsToDelete = [];
  bool editMode = false;
  bool expanded = false;
  int tmpCals = 0;

//edit entry
  void toggleEditMode() {
    setState(() {
      editMode = !editMode;
    });
  }

//add items to be deleted
  void addToDelete(String id) {
    setState(() {
      itemsToDelete = [...itemsToDelete, id];
    });
    print("................the items to be deleted are................");
    print(itemsToDelete);
  }

//add new food log to top of list
  void addFood(FoodLog food) {
    setState(() {
      items.insert(0, food);
      tmpCals += food.calories * food.num;
    });
  }

  void deleteFood(String foodid) {
    var tmpfood = items.firstWhere((element) => (element.id == foodid));
    setState(() {
      items.remove(tmpfood);
    });
  }

//add/minus/clear food num & update tmpcals
  void editFoodNum(String food, String type) {
    var tmpfood =
        items.firstWhere((element) => (element.name == food && !element.saved));
    if (type == "add") {
      setState(() {
        tmpfood.num += 1;
        tmpCals += tmpfood.calories;
      });
    } else if (type == "subtract") {
      setState(() {
        if (tmpfood.num == 1) {
          items.remove(tmpfood);
        } else {
          tmpfood.num -= 1;
        }
        tmpCals -= tmpfood.calories;
      });
    } else if (type == "clear") {
      setState(() {
        items.remove(tmpfood);
        tmpCals -= tmpfood.calories * tmpfood.num;
      });
    } else {
      print("not a valid view for editnum");
    }
  }

//delete all unsaved entries, reset tmpcals
  void clearAllSelected() {
    setState(() {
      items = items.where((element) => element.saved);
      tmpCals = 0;
    });
  }

  void saveItem(String food, String id) {
    var tmpfood =
        items.firstWhere((element) => (element.name == food && !element.saved));
    setState(() {
      tmpfood.saved = true;
      tmpfood.id = id;
    });
  }

  Future myFuture;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final user = Provider.of<UserData>(context, listen: false);
      final DatabaseService _db = DatabaseService(uid: user.uid);
      myFuture =
          _db.foodLogCollection.doc(user.uid).collection("userfoodlogs").get();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    final DatabaseService _db = DatabaseService(uid: user.uid);

    return FutureBuilder<QuerySnapshot>(
        future: myFuture,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (!snapshot.hasData) {
            return Center(child: Text("loading..."));
          }

          snapshot.data.docs.forEach((doc) {
            var tmpfood = items.firstWhere((element) => element.id == doc.id,
                orElse: () => null);
            final itemdate =
                DateTime.parse(doc['createdat'].toDate().toString());
            final itemday =
                DateTime(itemdate.year, itemdate.month, itemdate.day);
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            if ((tmpfood == null) && (itemday == today)) {
              items.add(FoodLog(
                  name: doc['name'],
                  num: doc['num'],
                  meal: doc['meal'],
                  calories: doc['calories'],
                  unit: doc['unit'],
                  createdat: doc['createdat'],
                  id: doc.id,
                  saved: true));
            }
          });
          items.sort((a, b) => b.createdat.compareTo(a.createdat));
          var mysum =
              items.fold(0, (sum, item) => sum + (item.calories * item.num));

          _db.profilesCollection.doc(user.uid).update({'dailyfood': mysum});

          return Column(
            children: [
              //calorie number
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Text(
                  "/1500",
                  style: Theme.of(context).textTheme.headline6,
                ),
                //TODO: daily recommended calorie limit
                Text(
                  user.dailyFood.toString(),
                  style: Theme.of(context).textTheme.headline4,
                ),
                IconButton(
                    icon: Icon(Icons.zoom_in),
                    onPressed: () => showDialog(
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
                                      "543 Cals",
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
                                            return ListTile(
                                              tileColor: items[i].saved
                                                  ? Colors.red[100]
                                                  : Colors.blue[100],
                                              leading: Text(
                                                  items[i].num.toString() +
                                                      "x"),
                                              title: Center(
                                                  child: Text(items[i].name +
                                                      DateFormat(
                                                              'yyyy-MM-dd hh:mm')
                                                          .format(items[i]
                                                              .createdat
                                                              .toDate())
                                                          .toString())),
                                              trailing: Text(
                                                  (items[i].calories *
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
                            )))
              ]),
              //menu
              Menu(
                  items: items,
                  addToDelete: addToDelete,
                  editMode: editMode,
                  deleteFood: deleteFood,
                  clearAllSelected: clearAllSelected,
                  saveItem: saveItem),
              //menu options (clear and view)

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
                  expanded: expanded,
                  editFoodNum: editFoodNum,
                  selectedGroup: selectedGroup,
                  foodLogs: items.where((element) => element.saved).toList(),
                  selectedFoods:
                      items.where((element) => !element.saved).toList(),
                  selectedMeal: selectedMeal),
            ],
          );
        });
  }
}

class Menu extends StatefulWidget {
  Menu({
    Key key,
    @required this.items,
    @required this.editMode,
    @required this.addToDelete,
    @required this.clearAllSelected,
    @required this.deleteFood,
    @required this.saveItem,
  }) : super(key: key);

  final List<FoodLog> items;
  final Function addToDelete;
  final Function clearAllSelected;
  final Function deleteFood;
  final Function saveItem;

  final bool editMode;

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    final DatabaseService _db = DatabaseService(uid: user.uid);

    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                  child: Align(
                alignment: Alignment.topCenter,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.items.length,
                    itemBuilder: (context, i) {
                      return Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              _db.deleteFoodLog(widget.items[i].id);
                              // widget.deleteFood(widget.items[i].id);

                              // _db.profilesCollection.doc(user.uid).update({
                              //   'dailyfood': FieldValue.increment(-1 *
                              //       widget.items[i].calories *
                              //       widget.items[i].num)
                              // });
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
                              item: widget.items[i],
                              addToDelete: widget.addToDelete,
                              editMode: widget.editMode));
                    }),
              )),
            ),
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
                          var saveFoodLogs = widget.items
                              .where((element) => !element.saved)
                              .toList();
                          for (FoodLog foodlog in saveFoodLogs) {
                            await _db.foodLogCollection
                                .doc(user.uid)
                                .collection("userfoodlogs")
                                .add({
                              'name': foodlog.name,
                              'createdat': Timestamp.now(),
                              'num': foodlog.num,
                              'meal': foodlog.meal,
                              'unit': foodlog.unit,
                              'calories': foodlog.calories
                            }).then((doc) =>
                                    widget.saveItem(foodlog.name, doc.id));
                          }
                          _db.profilesCollection.doc(user.uid).update({
                            'dailyfood': FieldValue.increment(saveFoodLogs.fold(
                                0,
                                (sum, item) =>
                                    sum + (item.calories * item.num)))
                          });
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
          ],
        ),
      ),
    );
  }
}

class FoodLogTile extends StatefulWidget {
  const FoodLogTile(
      {Key key,
      @required this.item,
      @required this.addToDelete,
      @required this.editMode})
      : super(key: key);

  final FoodLog item;
  final Function addToDelete;
  final bool editMode;

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
      onTap: () {
        if (widget.editMode) {
          setState(() {
            isSelected = !isSelected;
            mycolor = isSelected ? Colors.pink[300] : Colors.red[100];
          });
        }
      },
      tileColor: mycolor,
      leading: Text(widget.item.num.toString() + "x"),
      title: Center(child: Text(widget.item.name)),
      trailing:
          Text((widget.item.calories * widget.item.num).toString() + " cal"),
    );
  }
}
