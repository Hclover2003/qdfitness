import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/models/food.dart';
import 'package:qdfitness/screens/home/foodchoices.dart';

class CircleItem extends StatefulWidget {
  const CircleItem({
    Key key,
    @required this.food,
    @required this.selectedFoods,
    @required this.selectedMeal,
    @required this.addFood,
    @required this.editFoodNum,
  }) : super(key: key);

  final Food food;
  final List<FoodLog> selectedFoods;
  final String selectedMeal;
  final AddFood addFood;
  final Function editFoodNum;

  @override
  _CircleItemState createState() => _CircleItemState();
}

class _CircleItemState extends State<CircleItem> {
  String label;

  @override
  void initState() {
    super.initState();
    label = widget.food.name;
  }

  FoodLog foodInList() {
    var tmpfood = widget.selectedFoods
        .firstWhere((x) => x.name == widget.food.name, orElse: () => null);
    if (tmpfood == null) {
      return null;
    } else {
      return tmpfood;
    }
  }

  void clearAll() {
    print(widget.food.name + "will delete");
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    return Padding(
        padding: const EdgeInsets.all(14.0),
        child: GestureDetector(
          onTap: () {
            //if food is in list, add one to number of food
            if (foodInList() != null) {
              widget.editFoodNum(widget.food.name, "add");
              setState(() {
                label = foodInList().num.toString();
              });
              //if it isn't, add it and change label to 1
            } else {
              widget.addFood(FoodLog(
                  name: widget.food.name,
                  unit: widget.food.unit,
                  calories: widget.food.calories,
                  num: 1,
                  meal: widget.selectedMeal,
                  uid: user.uid,
                  createdat: Timestamp.now(),
                  saved: false));
              setState(() {
                label = '1';
              });
            }
          },
          child: Tooltip(
            message:
                "${widget.food.name}: ${widget.food.calories} cal/${widget.food.unit}",
            child: Stack(children: [
              Container(
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      foodInList() == null
                          ? widget.food.name
                          : foodInList().num.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          colorFilter: foodInList() != null
                              ? ColorFilter.mode(Colors.black.withOpacity(0.2),
                                  BlendMode.darken)
                              : ColorFilter.mode(Colors.black.withOpacity(0.6),
                                  BlendMode.darken),
                          image:
                              AssetImage('assets/img/${widget.food.name}.jpg')),
                      borderRadius: BorderRadius.all(Radius.circular(100)))),
              (() {
                if (foodInList() == null)
                  return Text("");
                else
                  return Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                          onTap: () {
                            widget.editFoodNum(widget.food.name, "clear");
                          },
                          child: Icon(Icons.delete)));
              }()),
              (() {
                if (foodInList() == null)
                  return Text("");
                else
                  return Positioned(
                      top: 0,
                      left: 0,
                      child: GestureDetector(
                          onTap: () {
                            widget.editFoodNum(widget.food.name, "subtract");
                          },
                          child: Icon(Icons.minimize)));
              }())
            ]),
          ),
        ));
  }
}
