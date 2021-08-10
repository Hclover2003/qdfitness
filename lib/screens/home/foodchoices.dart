import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/models/food.dart';
import 'package:qdfitness/screens/home/circleitem.dart';
import 'package:qdfitness/services/database.dart';

typedef void ClearFood(String foodname);
typedef void AddFood(FoodLog food);

class FoodChoices extends StatelessWidget {
  const FoodChoices({
    Key key,
    @required this.selectedGroup,
    @required this.selectedFoods,
    @required this.selectedMeal,
    @required this.clearFood,
    @required this.addFood,
    @required this.editFoodNum,
    @required this.expanded,
    @required this.subtractFoodNum,
  }) : super(key: key);

  final String selectedGroup;
  final List<FoodLog> selectedFoods;
  final String selectedMeal;
  final ClearFood clearFood;
  final AddFood addFood;
  final ClearFood editFoodNum;
  final ClearFood subtractFoodNum;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    final DatabaseService _db = DatabaseService(uid: user.uid);

    return FutureBuilder<QuerySnapshot>(
      future: _db.foodCollection.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (!snapshot.hasData) {
          return Text("loading...");
        }
        List<Food> foods = snapshot.data.docs
            .map((doc) => Food(
                name: doc.data()['name'],
                id: doc.id,
                group: doc.data()['group'],
                calories: doc.data()['calories'],
                unit: doc.data()['unit']))
            .toList();

        return !expanded
            ? SizedBox()
            : Expanded(
                flex: 2,
                child: Container(
                  color: Colors.white,
                  child: GridView.count(crossAxisCount: 3, children: [
                    for (var food in foods
                        .where((element) => (element.group == selectedGroup)))
                      CircleItem(
                          food: food,
                          clearFood: clearFood,
                          addFood: addFood,
                          subtractFoodNum: subtractFoodNum,
                          editFoodNum: editFoodNum,
                          selectedFoods: selectedFoods,
                          selectedMeal: selectedMeal)
                  ]),
                ),
              );
      },
    );
  }
}
