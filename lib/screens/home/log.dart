import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/services/database.dart';
import 'package:qdfitness/shared/constantfns.dart';
import 'package:qdfitness/shared/shared.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart';

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

  bool countCalories = false;
  double fistfuls;
  int caloriesPer100g;
  int calories = 0;
  String error = '';

  final fieldText = TextEditingController();
  final fieldText2 = TextEditingController();
  final fieldText3 = TextEditingController();
  void clearText() {
    fieldText.clear();
    fieldText2.clear();
    fieldText3.clear();
  }

  @override
  Widget build(BuildContext context) {
    final userdata = Provider.of<UserData>(context);
    final DatabaseService _db = DatabaseService(uid: userdata.uid);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Text(
              "Current: 102 Calories",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  height: 100.0,
                  width: 100,
                  decoration: logOption.copyWith(
                      color: _foodPressed ? apptheme.c1 : apptheme.c1l,
                      border: Border.all(
                          color: _foodPressed ? apptheme.c1 : apptheme.c1l)),
                  child: TextButton(
                    child: Text(
                      'Food',
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
                  height: 100.0,
                  width: 100,
                  decoration: logOption.copyWith(
                      color: _exercisePressed ? apptheme.c2 : apptheme.c2l,
                      border: Border.all(
                        color: _exercisePressed ? apptheme.c2 : apptheme.c2l,
                      )),
                  child: TextButton(
                    child: Text(
                      'Exercise',
                      style: TextStyle(
                          color: _exercisePressed ? apptheme.c2l : apptheme.c2),
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
                      color: _thoughtPressed ? apptheme.c3 : apptheme.c3l,
                      border: Border.all(
                        color: _thoughtPressed ? apptheme.c3 : apptheme.c3l,
                      )),
                  child: TextButton(
                    child: Text(
                      'Thought',
                      style: TextStyle(
                          color: _thoughtPressed ? apptheme.c3l : apptheme.c3),
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
        (() {
          return (_foodPressed | _exercisePressed)
              ? CheckboxListTile(
                  title: Text(
                    "count calories?",
                    style: TextStyle(fontSize: 14),
                  ),
                  value: countCalories,
                  onChanged: (newValue) {
                    setState(() {
                      countCalories = newValue;
                      print(countCalories);
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                )
              : SizedBox();
        }()),
        (() {
          return (countCalories & (_foodPressed | _exercisePressed))
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 55.0),
                  child: TextFormField(
                    controller: fieldText2,
                    onChanged: (val) {
                      setState(() => fistfuls = double.parse(val));
                      print(fistfuls);
                    },
                    decoration: logFormDecoration.copyWith(
                        hintText: _foodPressed ? 'fistfuls' : 'time exercised',
                        filled: true,
                        fillColor: _foodPressed ? apptheme.c1l : apptheme.c2l),
                    keyboardType: TextInputType.number,
                  ),
                )
              : SizedBox();
        }()),
        SizedBox(
          height: 10,
        ),
        (() {
          return (countCalories & _foodPressed)
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 55.0),
                  child: TextFormField(
                    controller: fieldText3,
                    onChanged: (val) {
                      setState(() => _note = val);
                    },
                    decoration: logFormDecoration.copyWith(
                        hintText: 'food name',
                        filled: true,
                        fillColor: _foodPressed ? apptheme.c1l : apptheme.c2l),
                  ),
                )
              : Container(
                  constraints: BoxConstraints(maxHeight: 200),
                  width: 250,
                  child: TextFormField(
                    controller: fieldText,
                    decoration: logFormDecoration.copyWith(
                        fillColor: _foodPressed
                            ? apptheme.c1l
                            : (_exercisePressed ? apptheme.c2l : apptheme.c3l),
                        hintText: 'note'),
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    autofocus: false,
                    validator: (val) => val.isEmpty ? 'enter note' : null,
                    onChanged: (val) {
                      setState(() => _note = val);
                    },
                  ));
        }()),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 10,
        ),
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
                }, currentTime: DateTime.now());
              },
              child: Text(DateFormat.MMMd().add_jm().format(_time),
                  style: TextStyle(
                      color: _foodPressed
                          ? apptheme.c1
                          : (_exercisePressed ? apptheme.c2 : apptheme.c3)))),
        ),
        (() {
          return (countCalories & (calories != null))
              ? Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    height: 50.0,
                    color: apptheme.c1l,
                    child: Center(
                      child: Text(
                          "$fistfuls fistfuls x $caloriesPer100g calories/100g = $calories calories"),
                    ),
                  ),
                )
              : SizedBox(
                  height: 15,
                );
        }()),
        (() {
          return (countCalories)
              ? SizedBox(
                  height: 60,
                  width: 100,
                  child: TextButton(
                    child: Text(
                      'search',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                        backgroundColor: _foodPressed
                            ? apptheme.c1
                            : (_exercisePressed ? apptheme.c2 : apptheme.c3)),
                    onPressed: () async {
                      Response response = await get(Uri.parse(
                          'https://world.openfoodfacts.org/category/$_note.json'));
                      print('success');

                      Map data = jsonDecode(response.body);
                      List products = data['products'];

                      if (products.length == 0) {
                        print('nothing found');
                        setState(() {
                          error = "nothing found";
                        });
                      } else {
                        List validproducts = products
                            .where((i) =>
                                i['nutriments']['energy-kcal_100g'] != null)
                            .toList();

                        for (var i in validproducts) {
                          print(i['categories_hierarchy']);
                        }

                        List kCalList = validproducts.map((e) {
                          if (e['nutriments']['energy-kcal_100g'] is String) {
                            return double.parse(
                                e['nutriments']['energy-kcal_100g']);
                          } else {
                            return e['nutriments']['energy-kcal_100g']
                                .toDouble();
                          }
                        }).toList();

                        kCalList.sort((a, b) => a.compareTo(b));
                        int medianIndex = kCalList.length ~/ 2;
                        double median = kCalList[medianIndex];

                        setState(() {
                          caloriesPer100g = median.toInt();
                          calories = (caloriesPer100g * 2.5 * fistfuls).toInt();
                        });
                      }
                    },
                  ),
                )
              : SizedBox();
        }()),
        SizedBox(height: 10),
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
              await _db.createNote(_note, _type, _time, fistfuls, calories);
              clearText();
              setState(() => _time = DateTime.now());
              Fluttertoast.showToast(
                  msg: "success! note added",
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
      ],
    );
  }
}
