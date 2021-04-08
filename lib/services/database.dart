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

  //update notes data
  Future<void> updateNoteData(String note, String type, DateTime time) async {
    return await notesCollection.doc(uid).collection("usernotes").doc().set({
      'note': note,
      'createdat': FieldValue.serverTimestamp(),
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
          createdat: doc.data()['createdat'],
          type: doc.data()['type']);
    }).toList();
  }

  //update user data
  Future<void> updateUserData(String name) async {
    return await profilesCollection.doc(uid).set({'name': name});
  }

  //userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data()['name'],
    );
  }

  //get userData stream
  Stream<UserData> get userData {
    return profilesCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
