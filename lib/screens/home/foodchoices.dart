import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/models/food.dart';
import 'package:qdfitness/screens/home/circleitem.dart';
import 'package:qdfitness/services/database.dart';

class FoodChoices extends StatelessWidget {
  const FoodChoices({
    Key key,
    @required this.selectedGroup,
    @required this.selectedFoods,
    @required this.selectedMeal,
    @required this.addFood,
    @required this.editFoodNum,
  }) : super(key: key);

  final String selectedGroup;
  final List<FoodLog> selectedFoods;
  final String selectedMeal;
  final Function addFood;
  final Function editFoodNum;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    final DatabaseService _db = DatabaseService(uid: user.uid);
    var foodlogs = Provider.of<List<FoodLog>>(context);

    Map<String, FoodLog> mp = {};
    for (var item in foodlogs) {
      if (!mp.containsKey(item.name)) {
        mp[item.name] = item;
      }
    }
    var filteredList = mp.values.toList();
    filteredList.sort((a, b) => b.createdat.compareTo(a.createdat));
    var recentfoodlogs = filteredList.sublist(
        0, filteredList.length > 12 ? 12 : filteredList.length);

    return FutureBuilder<QuerySnapshot>(
      future: _db.foodCollection.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (!snapshot.hasData) {
          return SizedBox(
            height: 0.25 * MediaQuery.of(context).size.height,
          );
        }
        List<Food> foods = snapshot.data.docs
            .map((doc) => Food(
                name: doc['name'],
                id: doc.id,
                group: doc['group'],
                calories: doc['calories'],
                unit: doc['unit']))
            .toList();

        foods.sort((a, b) => a.name.compareTo(b.name));

        return Expanded(
          flex: 4,
          child: Container(
            color: Colors.white,
            child: GridView.count(crossAxisCount: 3, children: [
              if (selectedGroup == 'recent')
                for (var food in recentfoodlogs)
                  CircleItem(
                      food: foods
                          .firstWhere((element) => element.name == food.name),
                      addFood: addFood,
                      editFoodNum: editFoodNum,
                      selectedFoods: selectedFoods,
                      selectedMeal: selectedMeal),
              for (var food
                  in foods.where((element) => (element.group == selectedGroup)))
                CircleItem(
                    food: food,
                    addFood: addFood,
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
