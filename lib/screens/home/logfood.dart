import 'dart:ui';

import 'package:flutter/material.dart';

class LogFood extends StatefulWidget {
  final List<String> meals = ['breakfast', 'lunch', 'dinner', 'snacks'];
  final List<String> foodGroups = ['grains', 'fruits', 'veggies'];
  final Map<String, List<String>> foodTypes = {
    'grains': ['rice', 'pasta', 'bread'],
    'fruits': ['common', 'tropical', 'berries'],
    'veggies': ['green', 'roots', 'colors']
  };
  final Map<String, List<String>> foodNames = {
    'rice': ['normal', 'fried', 'sticky'],
    'pasta': ['noodles', 'spaghetti', 'macandcheese'],
    'bread': ['white', 'wheat', 'sweet'],
    'common': ['apple', 'orange', 'pear'],
    'tropical': ['pineapple', 'mango', 'lychee'],
    'berries': ['blueberry', 'strawberry', 'grape']
  };

  @override
  _LogFoodState createState() => _LogFoodState();
}

class _LogFoodState extends State<LogFood> {
  String selectedMeal = (TimeOfDay.now().hour > 12)
      ? (TimeOfDay.now().hour > 16)
          ? "dinner"
          : "lunch"
      : "breakfast";

  String selectedGroup = "grain";
  String selectedType = "rice";
  List<String> selectedFoods = [];

  List<String> types;

  @override
  void initState() {
    super.initState();
    types = widget.foodTypes['grains'];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Center(
      child: Column(
        children: [
          Text(
            "189 cal",
            style: Theme.of(context).textTheme.headline4,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Center(child: TextButton(child: Text("-")))),
                Expanded(flex: 1, child: Center(child: Text("2"))),
                Expanded(flex: 1, child: Center(child: Text("+"))),
                Expanded(
                  flex: 5,
                  child: Center(child: Text("apples")),
                ),
                Expanded(
                  flex: 2,
                  child: Center(child: Text("29 cal")),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Center(child: TextButton(child: Text("-")))),
                Expanded(flex: 1, child: Center(child: Text("2"))),
                Expanded(flex: 1, child: Center(child: Text("+"))),
                Expanded(
                  flex: 5,
                  child: Center(child: Text("apples")),
                ),
                Expanded(
                  flex: 2,
                  child: Center(child: Text("29 cal")),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Center(child: TextButton(child: Text("-")))),
                Expanded(flex: 1, child: Center(child: Text("2"))),
                Expanded(flex: 1, child: Center(child: Text("+"))),
                Expanded(
                  flex: 5,
                  child: Center(child: Text("apples")),
                ),
                Expanded(
                  flex: 2,
                  child: Center(child: Text("29 cal")),
                )
              ],
            ),
          ),
          Row(
            children: [
              for (var i in widget.meals)
                foodBoxOption(i, 50, selectedMeal, 'meal')
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(children: [
            for (var i in widget.foodGroups)
              foodBoxOption(i, 50, selectedGroup, 'group')
          ]),
          SizedBox(
            height: 10,
          ),
          Row(children: [
            for (var i in types) foodBoxOption(i, 50, selectedType, 'type')
          ]),
          SizedBox(
            height: 10,
          ),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            children: [for (var i in widget.foodNames['rice']) foodOption(i)],
          )
        ],
      ),
    ));
  }

  Padding foodOption(String name) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (selectedFoods.contains(name)) {
              selectedFoods.remove(name);
            } else {
              selectedFoods.add(name);
            }
          });
        },
        child: Container(
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(100)),
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(
                            selectedFoods.contains(name) ? 0.8 : 0.2),
                        BlendMode.dstATop),
                    image: AssetImage(
                      "assets/images/$name.jpg",
                    ),
                    fit: BoxFit.cover)),
            child: Center(
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: selectedFoods.contains(name)
                      ? Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                child: Center(
                  child: Text(
                    name,
                    style: TextStyle(
                        color: selectedFoods.contains(name)
                            ? Colors.black
                            : Colors.white54),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Expanded foodBoxOption(
      String name, double height, String selectedName, String category) {
    return Expanded(
        flex: (selectedName == name) ? 4 : 2,
        child: GestureDetector(
          child: Container(
            height: (selectedName == name) ? height : 30,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                    Radius.circular((selectedName == name) ? 0 : 0)),
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black
                            .withOpacity(selectedName == name ? 0.7 : 0.2),
                        BlendMode.dstATop),
                    image: AssetImage(
                      "assets/images/$name.jpg",
                    ),
                    fit: BoxFit.cover)),
            child: Center(
              child: Text(
                selectedName == name ? name.toUpperCase() : name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color:
                        selectedName == name ? Colors.white : Colors.white24),
              ),
            ),
          ),
          onTap: () {
            setState(() {
              if (category == 'meal') {
                selectedMeal = name;
              } else if (category == 'group') {
                selectedGroup = name;
                types = widget.foodTypes[name];
                selectedType = widget.foodTypes[name][0];
                print(selectedType);
              } else {
                selectedType = name;
              }
            });
            print(name);
          },
        ));
  }
}
