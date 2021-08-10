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
