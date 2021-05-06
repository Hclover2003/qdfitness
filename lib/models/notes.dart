import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String type;
  String note;
  Timestamp createdat;
  Timestamp time;
  String id;
  double fistfuls;
  int calories;

  Note(
      {this.type,
      this.note,
      this.createdat,
      this.time,
      this.id,
      this.fistfuls,
      this.calories});
}
