import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String type;
  String note;
  Timestamp createdat;

  Note({this.type, this.note, this.createdat});
}
