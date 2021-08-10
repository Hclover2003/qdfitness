import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/models/food.dart';
import 'package:qdfitness/models/notes.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //collection references
  final CollectionReference notesCollection =
      FirebaseFirestore.instance.collection('notes');

  final CollectionReference profilesCollection =
      FirebaseFirestore.instance.collection('profiles');

  final CollectionReference foodCollection =
      FirebaseFirestore.instance.collection('foodData');
  final CollectionReference foodLogCollection =
      FirebaseFirestore.instance.collection('foodLogs');

//TOTAL DATA
//create
  Future<void> createTotal(DateTime date, int calories) async {
    return await notesCollection
        .doc(uid)
        .collection("usernotes")
        .doc()
        .set({'date': date, 'totalcal': calories});
  }

  //update
  Future<void> updateTotal(int calories, String id) async {
    return await notesCollection
        .doc(uid)
        .collection('usernotes')
        .doc(id)
        .update({'totalcal': 39});
  }

  //FOODS
  List<Food> _foodListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Food(
          name: doc.data()['name'],
          id: doc.id,
          group: doc.data()['group'],
          calories: doc.data()['calories'],
          unit: doc.data()['unit']);
    }).toList();
  }

  //get foods
  Stream<List<Food>> get foods {
    return foodCollection.snapshots().map(_foodListFromSnapshot);
  }

//FOODLOG
  Future<void> createFoodLog(FoodLog foodlog) async {
    return await foodLogCollection
        .doc(uid)
        .collection("userfoodlogs")
        .doc()
        .set({
      'name': foodlog.name,
      'createdat': Timestamp.now(),
      'num': foodlog.num,
      'meal': foodlog.meal,
      'unit': foodlog.unit,
      'calories': foodlog.calories
    });
  }

  List<FoodLog> _foodLogListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return FoodLog(
          name: doc.data()['name'],
          num: doc.data()['num'],
          meal: doc.data()['meal'],
          calories: doc.data()['calories'],
          unit: doc.data()['unit'],
          createdat: doc.data()['createdat'],
          saved: true);
    }).toList();
  }

  //get foods

  //NOTES
  //create note
  Future<void> createNote(String note, String type, DateTime time,
      double fistfuls, int calories) async {
    return await notesCollection.doc(uid).collection("usernotes").doc().set({
      'note': note,
      'createdat': FieldValue.serverTimestamp(),
      'type': type,
      'time': Timestamp.fromDate(time),
      'fistfuls': fistfuls,
      'calories': calories
    });
  }

  //update note
  Future<void> updateNote(
      String note, String type, DateTime time, String id) async {
    return await notesCollection
        .doc(uid)
        .collection('usernotes')
        .doc(id)
        .update({
      'note': note,
      'editedat': FieldValue.serverTimestamp(),
      'type': type,
      'time': Timestamp.fromDate(time)
    });
  }

//USER
  //update user document details
  Future<void> updateUserData(String name, String uid) async {
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

  //maps data from document snapshot -> UserData object
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.data()['name'],
        createdAt: snapshot.data()['createdAt'],
        dailyExercise: snapshot.data()['dailyexercise'],
        dailyFood: snapshot.data()['dailyfood'],
        weight: snapshot.data()['weight'],
        height: snapshot.data()['height'],
        age: snapshot.data()['age']);
  }

  //stream; gets doc info and maps to UserData
  Stream<UserData> get userData {
    return profilesCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

// get notes stream
  Stream<List<Note>> get notes {
    return notesCollection
        .doc(uid)
        .collection("usernotes")
        .snapshots()
        .map(_noteListFromSnapshot);
  }

// noteData from snapshot
  List<Note> _noteListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Note(
          note: doc.data()['note'],
          id: doc.id,
          createdat: doc.data()['createdat'],
          time: doc.data()['time'],
          type: doc.data()['type'],
          fistfuls: doc.data()['fistfuls'],
          calories: doc.data()['calories']);
    }).toList();
  }

//delete note
  Future<void> deleteNote(String id) async {
    return notesCollection.doc(uid).collection("usernotes").doc(id).delete();
  }

  Future<void> deleteFoodLog(String id) async {
    return foodLogCollection
        .doc(uid)
        .collection("userfoodlogs")
        .doc(id)
        .delete();
  }
}
