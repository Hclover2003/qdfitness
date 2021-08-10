import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/models/food.dart';
import 'package:qdfitness/screens/home/circleitem.dart';
import 'package:qdfitness/screens/home/foodchoices.dart';
import 'package:qdfitness/services/database.dart';

typedef void AddDelete(String id);

class LogFood extends StatefulWidget {
  final List<String> meals = ['breakfast', 'lunch', 'dinner', 'snacks'];
  final List<String> foodGroups = [
    'grain',
    'fruits',
    'vegetables',
    'protein',
    'other'
  ];

  @override
  _LogFoodState createState() => _LogFoodState();
}

class _LogFoodState extends State<LogFood> {
  //initialize selected as breakfast and grain
  String selectedMeal = "breakfast";
  String selectedGroup = "grain";
  List<FoodLog> selectedFoods = [];
  List<FoodLog> items = [];
  List<bool> _selections = [false, false, false];
  List<String> itemsToDelete = [];
  bool editMode = false;
  bool expanded = false;

  void toggleEditMode() {
    setState(() {
      editMode = !editMode;
    });
  }

  void addToDelete(String id) {
    setState(() {
      itemsToDelete = [...itemsToDelete, id];
    });
    print(itemsToDelete);
  }

  void clearFood(String food) {
    try {
      setState(() {
        selectedFoods.removeWhere((element) => element.name == food);
      });
    } catch (e) {
      print("error removing food" + e);
    }
  }

  void addFood(FoodLog food) {
    setState(() {
      items.insert(0, food);
    });
  }

  void editFoodNum(String food) {
    setState(() {
      var tmpfood = items
          .firstWhere((element) => (element.name == food) && (!element.saved));
      tmpfood.num += 1;
    });
  }

  void subtractFoodNum(String food) {
    setState(() {
      var tmpfood = selectedFoods.firstWhere((element) => element.name == food);
      if (tmpfood.num == 1) {
        selectedFoods.remove(tmpfood);
      } else {
        tmpfood.num -= 1;
      }
    });
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    final DatabaseService _db = DatabaseService(uid: user.uid);
    return FutureBuilder<QuerySnapshot>(
        future: _db.foodLogCollection
            .doc(user.uid)
            .collection("userfoodlogs")
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (!snapshot.hasData) {
            return Text("loading...");
          }

          snapshot.data.docs.forEach((doc) {
            var tmpfood = items.firstWhere((element) => element.id == doc.id,
                orElse: () => null);
            if (tmpfood == null) {
              items.add(FoodLog(
                  name: doc.data()['name'],
                  num: doc.data()['num'],
                  meal: doc.data()['meal'],
                  calories: doc.data()['calories'],
                  unit: doc.data()['unit'],
                  createdat: doc.data()['createdat'],
                  id: doc.id,
                  saved: true));
            }
          });
          items.sort((a, b) => b.createdat.compareTo(a.createdat));

          return Column(
            children: [
              //calorie number
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: editMode ? Colors.purple : Colors.grey,
                    ),
                    onPressed: toggleEditMode),
                IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: editMode ? Colors.red : Colors.grey,
                    ),
                    onPressed: toggleEditMode),
                Text(
                  "543 Cal",
                  style: Theme.of(context).textTheme.headline4,
                ),
                IconButton(
                    icon: Icon(Icons.expand),
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
                                          controller: _scrollController,
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
                  selectedFoods: selectedFoods,
                  items: items,
                  scrollController: _scrollController,
                  addToDelete: addToDelete,
                  editMode: editMode),
              //menu options (clear and view)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          items =
                              items.where((element) => element.saved).toList();
                        });
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
                            var saveFoodLogs = items
                                .where((element) => !element.saved)
                                .toList();
                            print(saveFoodLogs);
                            for (FoodLog foodlog in saveFoodLogs) {
                              await _db.createFoodLog(foodlog);
                            }
                            print(
                                "...............................success!...............................");
                          },
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(15)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
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

              GestureDetector(
                onTap: () {
                  setState(() {
                    expanded = !expanded;
                  });
                },
                child: Container(
                  height: 50,
                  color: Colors.grey[800],
                ),
              ),
              //meal
              Row(children: [
                for (var i in widget.meals)
                  Expanded(
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedMeal = i;
                            });
                          },
                          child: Container(
                            color: (selectedMeal == i)
                                ? Color.fromRGBO(59, 65, 79, 1)
                                : Colors.white,
                            height: 40,
                            child: Center(
                              child: Text(
                                i,
                                style: TextStyle(
                                    color: (selectedMeal == i)
                                        ? Colors.white70
                                        : Color.fromRGBO(59, 65, 79, 1)),
                              ),
                            ),
                          )))
              ]),
              //food group
              Row(children: [
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
                      height: 40,
                      child: Center(
                        child: Text(
                          i,
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
                  clearFood: clearFood,
                  addFood: addFood,
                  expanded: expanded,
                  editFoodNum: editFoodNum,
                  subtractFoodNum: subtractFoodNum,
                  selectedGroup: selectedGroup,
                  selectedFoods:
                      items.where((element) => !element.saved).toList(),
                  selectedMeal: selectedMeal),
            ],
          );
        });
  }
}

class Menu extends StatefulWidget {
  const Menu({
    Key key,
    @required this.selectedFoods,
    @required ScrollController scrollController,
    @required this.items,
    @required this.editMode,
    @required this.addToDelete,
  })  : _scrollController = scrollController,
        super(key: key);

  final List<FoodLog> selectedFoods;
  final List<FoodLog> items;
  final Function addToDelete;
  final bool editMode;

  final ScrollController _scrollController;

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    final DatabaseService _db = DatabaseService(uid: user.uid);

    return Expanded(
      child: SizedBox(
          child: Align(
        alignment: Alignment.topCenter,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.items.length,
            controller: widget._scrollController,
            itemBuilder: (context, i) {
              return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      await _db
                          .deleteFoodLog(widget.items[i].id)
                          .then((value) => print('success'));
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
    if (widget.item.saved) {
      setState(() {
        mycolor = Colors.red[100];
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
