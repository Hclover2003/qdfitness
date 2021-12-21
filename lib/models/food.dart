import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  String name;
  String group;
  String unit;
  int calories;
  String id;

  @override
  String toString() {
    return "$name/$calories cals";
  }

  Food({
    this.name,
    this.group,
    this.unit,
    this.calories,
    this.id,
  });
}

class FoodLog {
  String name;
  String unit;
  int calories;
  int num;
  String meal;
  Timestamp createdat;
  String uid;
  String id;

  bool saved;
  @override
  String toString() {
    return "$num $name /$meal/$calories cals";
  }

  FoodLog(
      {this.name,
      this.calories,
      this.unit,
      this.num,
      this.meal,
      this.createdat,
      this.uid,
      this.id,
      this.saved});
}

class DailySummary {
  DateTime date;
  int grain;
  int protein;
  int fruit;
  int veg;
  int dairy;
  int other;
  int food;
  int exercise;
  String id;

  bool saved;
  @override
  String toString() {
    return "food total: $food /exercise: $exercise/ $date ";
  }

  DailySummary(
      {this.food,
      this.exercise,
      this.grain,
      this.fruit,
      this.veg,
      this.protein,
      this.dairy,
      this.other,
      this.date,
      this.id});
}
