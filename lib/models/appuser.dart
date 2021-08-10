import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  //final: property that won't change as user goes between diff screens
  final String uid;

  int dailyCalorieTotal;

  //set property in constructor; named parameters
  AppUser({this.uid, this.dailyCalorieTotal});
}

class UserData {
  final String uid;
  final String name;
  final Timestamp createdAt;
  final int dailyFood;
  final int dailyExercise;
  final double weight;
  final double height;
  final int age;

  UserData(
      {this.uid,
      this.name,
      this.createdAt,
      this.dailyExercise,
      this.dailyFood,
      this.weight,
      this.height,
      this.age});
}
