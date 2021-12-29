import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/models/exercise.dart';
import 'package:qdfitness/models/food.dart';
import 'package:qdfitness/models/notes.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //collection references
  final CollectionReference<Map<String, dynamic>> profilesCollection =
      FirebaseFirestore.instance.collection('profiles');

  final CollectionReference<Map<String, dynamic>> summariesCollection =
      FirebaseFirestore.instance.collection('dailySummaries');

  final CollectionReference<Map<String, dynamic>> foodCollection =
      FirebaseFirestore.instance.collection('foodData');

  final CollectionReference<Map<String, dynamic>> foodLogCollection =
      FirebaseFirestore.instance.collection('foodLogs');

      final CollectionReference<Map<String, dynamic>> exerciseCollection =
      FirebaseFirestore.instance.collection('exerciseData');

  final CollectionReference<Map<String, dynamic>> exerciseLogCollection =
      FirebaseFirestore.instance.collection('exerciseLogs');

//FOODS
  //get foods
  Stream<List<Food>> get foods {
    return foodCollection.snapshots().map(_foodListFromSnapshot);
  }

  List<Food> _foodListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Food(
          name: doc['name'],
          id: doc.id,
          group: doc['group'],
          calories: doc['calories'],
          unit: doc['unit']);
    }).toList();
  }

//FOODLOG
  //create foodlog
  Future<void> createFoodLog(FoodLog foodlog) async {
    return await foodLogCollection.doc(uid).collection("userfoodlogs").add({
      'name': foodlog.name,
      'createdat': Timestamp.now(),
      'num': foodlog.num,
      'meal': foodlog.meal,
      'unit': foodlog.unit,
      'calories': foodlog.calories
    });
  }

  //get foodlogs stream
  Stream<List<FoodLog>> get foodlogs {
    return foodLogCollection
        .doc(uid)
        .collection("userfoodlogs")
        .snapshots()
        .map(_foodLogListFromSnapshot);
  }

  List<FoodLog> _foodLogListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return FoodLog(
          name: doc['name'],
          num: doc['num'],
          meal: doc['meal'],
          calories: doc['calories'],
          unit: doc['unit'],
          createdat: doc['createdat'],
          id: doc.id,
          saved: true);
    }).toList();
  }

  //delete foodlog
  Future<void> deleteFoodLog(String id) async {
    return foodLogCollection
        .doc(uid)
        .collection("userfoodlogs")
        .doc(id)
        .delete()
        .then((value) => print("item deleted successfully"));
  }

//USER
  //update user document details
  Future<void> createUserData(String name, String uid) async {
    return await profilesCollection.doc(uid).set({
      'name': name,
      'createdAt': Timestamp.now(),
      'dailyfood': 0,
      'dailyexercise': 0,
      'weight': 55.0,
      'height': 160.0,
      'age': 18
    });
  }

  //get userdata stream
  Stream<UserData> get userData {
    return profilesCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot['name'],
        createdAt: snapshot['createdAt'],
        dailyExercise: snapshot['dailyexercise'],
        dailyFood: snapshot['dailyfood'],
        weight: snapshot['weight'],
        height: snapshot['height'],
        age: snapshot['age']);
  }

//DAILYSUMMARIES
  //create summary
  Future<void> createNewSummary() async {
    return await summariesCollection
        .doc(uid)
        .collection("userdailysummaries")
        .doc()
        .set({
      'date': Timestamp.now(),
      'food': 0,
      'exercise': 0,
      'grain': 0,
      'veg': 0,
      'fruit': 0,
      'dairy': 0,
      'protein': 0,
      'other': 0
    }).then((value) => print("created daily summary"));
  }

  Stream<List<DailySummary>> get dailysummaries {
    return summariesCollection
        .doc(uid)
        .collection("userdailysummaries")
        .snapshots()
        .map(_dailySummaryListFromSnapshot);
  }

  List<DailySummary> _dailySummaryListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return DailySummary(
          date: doc['date'].toDate(),
          food: doc['food'],
          exercise: doc['exercise'],
          grain: doc['grain'],
          veg: doc['veg'],
          fruit: doc['fruit'],
          dairy: doc['dairy'],
          protein: doc['protein'],
          other: doc['other'],
          id: doc.id);
    }).toList();
  }

  //EXERCISELOG
  //create exerciselog
  Future<void> createExerciseLog(ExerciseLog exerciselog) async {
    return await exerciseLogCollection.doc(uid).collection("userexerciselogs").add({
      'name': exerciselog.name,
      'createdat': Timestamp.now(),
      'hours': exerciselog.hours,
      'calories': exerciselog.calories
    });
  }

  //get exerciselogs stream
  Stream<List<ExerciseLog>> get exerciselogs {
    return exerciseLogCollection
        .doc(uid)
        .collection("userexerciselogs")
        .snapshots()
        .map(_exerciseLogListFromSnapshot);
  }

  List<ExerciseLog> _exerciseLogListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ExerciseLog(
          name: doc['name'],
          hours: doc['hours'],
          calories: doc['calories'],
          createdat: doc['createdat'],
          id: doc.id,
          saved: true);
    }).toList();
  }

  //delete exerciseLog
  Future<void> deleteExerciseLog(String id) async {
    return exerciseLogCollection
        .doc(uid)
        .collection("userexerciselogs")
        .doc(id)
        .delete()
        .then((value) => print("item deleted successfully"));
  }
}

