import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qdfitness/models/notes.dart';
import 'package:qdfitness/services/database.dart';
import 'package:qdfitness/shared/shared.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class EditNote extends StatefulWidget {
  final Note note;
  final String uid;
  EditNote({this.note, this.uid});
  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  String _note;
  String _type;
  DateTime _time;

  bool _foodPressed;
  bool _exercisePressed;
  bool _thoughtPressed;

  @override
  void initState() {
    super.initState();
    _note = widget.note.note;
    _type = widget.note.type;
    _time = widget.note.time.toDate();

    _foodPressed = (_type == 'food');
    _exercisePressed = (_type == 'exercise');
    _thoughtPressed = (_type == 'thought');
  }

  double _height = 20.0;

  @override
  Widget build(BuildContext context) {
    final DatabaseService _db = DatabaseService(uid: widget.uid);

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //type
                Container(
                    height: _height,
                    width: 100,
                    decoration: logOption.copyWith(
                        color: _foodPressed ? apptheme.c1 : apptheme.c1l,
                        border: Border.all(
                            color: _foodPressed ? apptheme.c1 : apptheme.c1l)),
                    child: TextButton(
                      child: Text(
                        '',
                        style: TextStyle(
                            color: _foodPressed ? apptheme.c1l : apptheme.c1),
                      ),
                      onPressed: () {
                        setState(() {
                          if (!_foodPressed) {
                            _foodPressed = true;
                            _thoughtPressed = false;
                            _exercisePressed = false;
                            setState(() {
                              _type = 'food';
                            });
                          }
                        });
                      },
                    )),
                Container(
                    height: _height,
                    width: 100,
                    decoration: logOption.copyWith(
                        color: _exercisePressed ? apptheme.c2 : apptheme.c2l,
                        border: Border.all(
                          color: _exercisePressed ? apptheme.c2 : apptheme.c2l,
                        )),
                    child: TextButton(
                      child: Text(
                        '',
                        style: TextStyle(
                            color:
                                _exercisePressed ? apptheme.c2l : apptheme.c2),
                      ),
                      onPressed: () {
                        setState(() {
                          if (!_exercisePressed) {
                            _exercisePressed = true;
                            _thoughtPressed = false;
                            _foodPressed = false;
                            setState(() => _type = 'exercise');
                          }
                        });
                      },
                    )),
                Container(
                    height: _height,
                    width: 100,
                    decoration: logOption.copyWith(
                        color: _thoughtPressed ? apptheme.c3 : apptheme.c3l,
                        border: Border.all(
                          color: _thoughtPressed ? apptheme.c3 : apptheme.c3l,
                        )),
                    child: TextButton(
                      child: Text(
                        '',
                        style: TextStyle(
                            color:
                                _thoughtPressed ? apptheme.c3l : apptheme.c3),
                      ),
                      onPressed: () {
                        setState(() {
                          if (!_thoughtPressed) {
                            _thoughtPressed = true;
                            _exercisePressed = false;
                            _foodPressed = false;
                            setState(() => _type = 'thought');
                          }
                        });
                      },
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          //note
          Container(
              constraints: BoxConstraints(maxHeight: 200),
              width: 250,
              child: TextFormField(
                initialValue: _note,
                decoration: logFormDecoration.copyWith(
                    fillColor: _foodPressed
                        ? apptheme.c1l
                        : (_exercisePressed ? apptheme.c2l : apptheme.c3l)),
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                autofocus: false,
                validator: (val) => val.isEmpty ? 'enter note' : null,
                onChanged: (val) {
                  setState(() => _note = val);
                },
              )),
          SizedBox(
            height: 20,
          ),
          //time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: logTime.copyWith(
                  color: _foodPressed
                      ? apptheme.c1l
                      : (_exercisePressed ? apptheme.c2l : apptheme.c3l),
                ),
                width: 250,
                child: TextButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          minTime: DateTime.now().subtract(Duration(days: 2)),
                          maxTime: DateTime.now().add(Duration(days: 2)),
                          onChanged: (date) {
                        print('change $date');
                      }, onConfirm: (date) {
                        print('confirm $date');
                        setState(() => _time = date);
                      }, currentTime: _time);
                    },
                    child: Text(DateFormat.MMMd().add_jm().format(_time),
                        style: TextStyle(
                            color: _foodPressed
                                ? apptheme.c1
                                : (_exercisePressed
                                    ? apptheme.c2
                                    : apptheme.c3)))),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          //submit
          SizedBox(
            height: 60,
            width: 100,
            child: TextButton(
              child: Text(
                'submit',
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                  backgroundColor: _foodPressed
                      ? apptheme.c1
                      : (_exercisePressed ? apptheme.c2 : apptheme.c3)),
              onPressed: () async {
                await _db.updateNote(_note, _type, _time, widget.note.id);
                Fluttertoast.showToast(
                    msg: "success! note edited",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.TOP,
                    backgroundColor: _foodPressed
                        ? apptheme.c1l
                        : (_exercisePressed ? apptheme.c2l : apptheme.c3l),
                    fontSize: 20,
                    textColor: _foodPressed
                        ? apptheme.c1
                        : (_exercisePressed ? apptheme.c2 : apptheme.c3));
              },
            ),
          ),
          SizedBox(
            height: 30.0,
          )
        ],
      ),
    );
  }
}
