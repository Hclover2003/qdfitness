import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/models/food.dart';
import 'package:qdfitness/models/notes.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //collection references
  final CollectionReference<Map<String, dynamic>> notesCollection =
      FirebaseFirestore.instance.collection('notes');

  final CollectionReference<Map<String, dynamic>> profilesCollection =
      FirebaseFirestore.instance.collection('profiles');

  final CollectionReference<Map<String, dynamic>> summariesCollection =
      FirebaseFirestore.instance.collection('dailySummaries');

  final CollectionReference<Map<String, dynamic>> foodCollection =
      FirebaseFirestore.instance.collection('foodData');

  final CollectionReference<Map<String, dynamic>> foodLogCollection =
      FirebaseFirestore.instance.collection('foodLogs');

//TOTAL DATA
//create
  Future<void> createSummary(DateTime date, int calories) async {
    return await summariesCollection
        .doc(uid)
        .collection("userdailysummaries")
        .doc()
        .set({'date': date, 'totalcal': FieldValue.increment(calories)});
  }

//FOODS
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

  //get foods
  Stream<List<Food>> get foods {
    return foodCollection.snapshots().map(_foodListFromSnapshot);
  }

//FOODLOG
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
        name: snapshot['name'],
        createdAt: snapshot['createdAt'],
        dailyExercise: snapshot['dailyexercise'],
        dailyFood: snapshot['dailyfood'],
        weight: snapshot['weight'],
        height: snapshot['height'],
        age: snapshot['age']);
  }

  //stream; gets doc info and maps to UserData
  Stream<UserData> get userData {
    return profilesCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

//NOTES
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
          note: doc['note'],
          id: doc.id,
          createdat: doc['createdat'],
          time: doc['time'],
          type: doc['type'],
          fistfuls: doc['fistfuls'],
          calories: doc['calories']);
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
}
