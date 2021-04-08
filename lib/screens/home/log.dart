import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/services/database.dart';
import 'package:qdfitness/shared/shared.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class Log extends StatefulWidget {
  @override
  _LogState createState() => _LogState();
}

class _LogState extends State<Log> {
  bool _foodPressed = true;
  bool _exercisePressed = false;
  bool _thoughtPressed = false;

  String _note = "";
  String _type = "food";
  DateTime _time = DateTime.now();

  final fieldText = TextEditingController();
  void clearText() {
    fieldText.clear();
  }

  @override
  Widget build(BuildContext context) {
    final userdata = Provider.of<UserData>(context);
    final DatabaseService _db = DatabaseService(uid: userdata.uid);

    return Stack(children: [
      Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.2), BlendMode.dstATop),
                image: AssetImage("assets/images/8.png"),
                fit: BoxFit.cover)),
      ),
      Column(
        children: [
          Text("choose a category"),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    height: 100.0,
                    width: 100,
                    decoration: logOption.copyWith(
                        color: _foodPressed ? myRed : myPink,
                        border:
                            Border.all(color: _foodPressed ? myRed : myPink)),
                    child: TextButton(
                      child: Text(
                        'Food',
                        style: TextStyle(color: _foodPressed ? myPink : myRed),
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
                    height: 100.0,
                    width: 100,
                    decoration: logOption.copyWith(
                        color: _exercisePressed ? myBlue : myLBlue,
                        border: Border.all(
                          color: _exercisePressed ? myBlue : myLBlue,
                        )),
                    child: TextButton(
                      child: Text(
                        'Exercise',
                        style: TextStyle(
                            color: _exercisePressed ? myLBlue : myBlue),
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
                    height: 100.0,
                    width: 100,
                    decoration: logOption.copyWith(
                        color: _thoughtPressed ? myYellow : myLYellow,
                        border: Border.all(
                          color: _thoughtPressed ? myYellow : myLYellow,
                        )),
                    child: TextButton(
                      child: Text(
                        'Thought',
                        style: TextStyle(
                            color: _thoughtPressed ? myLYellow : myYellow),
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
          Text("write a note"),
          SizedBox(
            height: 10,
          ),
          Container(
              constraints: BoxConstraints(maxHeight: 200),
              width: 250,
              child: TextFormField(
                controller: fieldText,
                decoration: logFormDecoration.copyWith(
                    fillColor: _foodPressed
                        ? myPink
                        : (_exercisePressed ? myLBlue : myLYellow)),
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                autofocus: false,
                validator: (val) => val.isEmpty ? 'enter note' : null,
                onChanged: (val) {
                  setState(() => _note = val);
                },
              )),
          SizedBox(
            height: 10,
          ),
          Text("set a time"),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: logTime.copyWith(
                  color: _foodPressed
                      ? myPink
                      : (_exercisePressed ? myLBlue : myLYellow),
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
                      }, currentTime: DateTime.now());
                    },
                    child: Text(DateFormat.MMMd().add_jm().format(_time),
                        style: TextStyle(
                            color: _foodPressed
                                ? myRed
                                : (_exercisePressed ? myBlue : myYellow)))),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
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
                      ? myRed
                      : (_exercisePressed ? myBlue : myYellow)),
              onPressed: () async {
                await _db.updateNoteData(_note, _type, _time);
                clearText();
                setState(() => _time = DateTime.now());
                Fluttertoast.showToast(
                    msg: "success! note added",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.TOP,
                    backgroundColor: _foodPressed
                        ? myPink
                        : (_exercisePressed ? myLBlue : myLYellow),
                    fontSize: 20,
                    textColor: _foodPressed
                        ? myRed
                        : (_exercisePressed ? myBlue : myYellow));
              },
            ),
          ),
        ],
      )
    ]);
  }
}
