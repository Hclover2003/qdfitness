import 'package:flutter/material.dart';
import 'package:qdfitness/models/food.dart';
import 'package:qdfitness/shared/shared.dart';

class LogFood2 extends StatefulWidget {
  final List<String> meals = ['breakfast', 'lunch', 'dinner', 'snacks'];
  final List<String> foodGroups = [
    'grain',
    'fruits',
    'dairy',
    'protein',
    'other'
  ];

  final List foods = [
    {"group": "grain", "name": "steamed bun", "calories": 218, "unit": "100g"},
    {
      "group": "grain",
      "name": "english muffin",
      "calories": 235,
      "unit": "100g"
    },
    {
      "group": "grain",
      "name": "whole wheat bread",
      "calories": 247,
      "unit": "100g"
    },
    {"group": "grain", "name": "white bread", "calories": 265, "unit": "100g"},
    {"group": "grain", "name": "sweet bread", "calories": 310, "unit": "100g"},
    {"group": "grain", "name": "oatmeal", "calories": 68, "unit": "100g"},
    {"group": "fruits", "name": "honeydew", "calories": 36, "unit": "100g"},
    {"group": "fruits", "name": "orange", "calories": 47, "unit": "100g"},
    {"group": "fruits", "name": "tomato", "calories": 22, "unit": "100g"},
  ];

  final Function toggleView;
  LogFood2({this.toggleView});

  @override
  _LogFood2State createState() => _LogFood2State();
}

class _LogFood2State extends State<LogFood2> {
  String selectedMeal = "breakfast";
  String selectedGroup = "grain";
  List<Food> selectedFoods = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
            child: Text(
          "543 Cal",
          style: Theme.of(context).textTheme.headline4,
        )),
        Flexible(
          child: SizedBox(
              height: MediaQuery.of(context).size.longestSide * 0.5,
              child: ListView.builder(itemBuilder: (context, i) {
                return ListTile(
                  leading: Text("1x"),
                  title: Center(child: Text("bagel")),
                  trailing: Text("23 cal"),
                );
              })),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Stack(
            children: [
              Positioned(
                  child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () => setState(() {
                            selectedFoods = [];
                          }),
                      child: Text("delete")),
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
                ],
              )),
            ],
          ),
        ),
        Expanded(
            child: Container(
          color: Colors.white,
          child: GridView.count(crossAxisCount: 3, children: [
            for (var i in widget.foods
                .where((x) => x['group'] == selectedGroup)
                .toList())
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: GestureDetector(
                  onTap: () {
                    var foodinlist = selectedFoods.firstWhere(
                        (x) => x.name == i['name'],
                        orElse: () => null);
                    if (foodinlist != null) {
                      foodinlist.num += 1;
                    } else {
                      selectedFoods.add(Food(
                          name: i['name'], calories: i['calories'], num: 1));
                    }
                    selectedFoods.forEach((element) {
                      print(element.name + element.num.toString());
                    });
                  },
                  child: Container(
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Tooltip(
                          message: "unit is: " + i['unit'],
                          child: Text(
                            selectedFoods.firstWhere((x) => x.name == i['name'],
                                        orElse: () => null) ==
                                    null
                                ? i['name']
                                : 1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius:
                              BorderRadius.all(Radius.circular(100)))),
                ),
              ),
          ]),
        )),
      ],
    );
  }
}
