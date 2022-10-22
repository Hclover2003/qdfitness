import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  //final: property that won't change as user goes between diff screens
  final String uid;
  //set property in constructor; named parameters
  AppUser({this.uid});
}

class UserData {
  final String uid;
  final String name;
  final Timestamp createdAt;
  final double weight;
  final double height;
  final int age;

  UserData(
      {this.uid,
      this.name,
      this.createdAt,
      this.weight,
      this.height,
      this.age});
}
