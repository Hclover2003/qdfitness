import 'dart:ui';

import 'package:flutter/material.dart';

class LogFood extends StatefulWidget {
  @override
  _LogFoodState createState() => _LogFoodState();
}

class _LogFoodState extends State<LogFood> {
  String selectedMeal = (TimeOfDay.now().hour > 12)
      ? (TimeOfDay.now().hour > 16)
          ? "dinner"
          : "lunch"
      : "breakfast";

  String selectedGrain = "rice";
  String selectedFruit = "common";
  String selectedVeggie = "leaves";
  String selectedDairy = "milk";
  String selectedDrink = "nocal";

  Color grainColor = Colors.orange;
  Color fruitColor = Colors.pinkAccent;
  Color veggieColor = Colors.lightGreen;
  Color dairyColor = Colors.blueAccent;
  Color drinkColor = Colors.yellow[600];
  Color othersColor = Colors.purple[100];

  TabController _grainController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Center(
      child: Column(
        children: [
          Text("189cal"),
          Container(
            width: 100,
            height: 10,
            color: Colors.red,
          ),
          Row(
            children: [
              mealOption("breakfast"),
              mealOption("lunch"),
              mealOption("dinner"),
              mealOption("snack"),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(children: [
            typeOption("rice", grainColor),
            typeOption("pasta", grainColor),
            typeOption("bread", grainColor),
            typeOption("other", grainColor),
          ]),
          Row(children: [
            typeOption("common", fruitColor),
            typeOption("berries", fruitColor),
            typeOption("melons", fruitColor),
            typeOption("tropical", fruitColor),
          ]),
          Row(children: [
            typeOption("leaves", veggieColor),
            typeOption("fruits", veggieColor),
            typeOption("stems", veggieColor),
            typeOption("bulbs", veggieColor),
          ]),
          Row(children: [
            typeOption("milk", dairyColor),
            typeOption("cheese", dairyColor),
            typeOption("yogurt", dairyColor),
            typeOption("sweets", dairyColor),
          ]),
          Row(children: [
            typeOption("nocal", drinkColor),
            typeOption("soup", drinkColor),
            typeOption("pop", drinkColor),
            typeOption("juice", drinkColor),
          ]),
        ],
      ),
    ));
  }

  Expanded typeOption(String type, Color color) {
    return Expanded(
      flex: (selectedGrain == type) ? 3 : 1,
      child: TextButton(
        onPressed: () {
          setState(() {
            selectedGrain = type;
          });
        },
        child: Text(
          type,
          style: TextStyle(color: Colors.white70),
        ),
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            )),
            backgroundColor: MaterialStateProperty.all(color)),
      ),
    );
  }

  Expanded mealOption(String meal) {
    return Expanded(
        flex: (selectedMeal == meal) ? 4 : 2,
        child: GestureDetector(
          child: Container(
            height: 200,
            decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black
                            .withOpacity(selectedMeal == meal ? 0.8 : 0.2),
                        BlendMode.dstATop),
                    image: AssetImage(
                      "assets/images/$meal.jpg",
                    ),
                    fit: BoxFit.cover)),
            child: Center(
              child: Text(
                meal,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color:
                        selectedMeal == meal ? Colors.white : Colors.white70),
              ),
            ),
          ),
          onTap: () {
            setState(() {
              selectedMeal = meal;
            });
            print(meal);
          },
        ));
  }
}
