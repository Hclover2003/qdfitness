import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/models/notes.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference notesCollection =
      FirebaseFirestore.instance.collection('notes');
  final CollectionReference profilesCollection =
      FirebaseFirestore.instance.collection('profiles');

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

//USER
  //update user document details
  Future<void> updateUserData(String name) async {
    return await profilesCollection.doc(uid).set(
        {'name': name, 'createdAt': DateTime.now().millisecondsSinceEpoch});
  }

  //maps data from document snapshot -> UserData object
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.data()['name'],
        createdAt: snapshot.data()['createdAt']);
  }

  //stream; gets doc info and maps to UserData
  Stream<UserData> get userData {
    return profilesCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
