import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  String name;
  String group;
  double veryLight;
  double light;
  double moderate;
  double intense;
  double veryIntense;
  String id;

  Exercise({
    this.name,
    this.group,
    this.light,
    this.veryLight,
    this.moderate,
    this.intense,
    this.veryIntense,
    this.id,
  });

  Map<String, dynamic> _toMap() {
    return {
      'light': light,
      'veryLight': veryLight,
      'moderate': moderate,
      'intense': intense,
      'veryIntense': veryIntense
    };
  }

  dynamic get(String propertyName) {
    var _mapRep = _toMap();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('propery not found');
  }

  @override
  String toString() {
    return "$name/$group, moderate: $moderate";
  }
}

class ExerciseLog {
  String name;
  int calories;
  double hours;
  Timestamp createdat;
  String uid;
  String id;
  bool saved;

  @override
  String toString() {
    return "$num $name /$hours/$calories cals";
  }

  ExerciseLog(
      {this.name,
      this.calories,
      this.hours,
      this.createdat,
      this.uid,
      this.id,
      this.saved});
}
