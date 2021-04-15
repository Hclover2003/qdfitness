import 'package:flutter/material.dart';
import 'package:qdfitness/models/themes.dart';

//COLOURS
//themeone
final themeone = AppTheme(
  name: 'basic three',
  c1: Color.fromRGBO(228, 94, 94, 1),
  c2: Color.fromRGBO(40, 152, 170, 1),
  c3: Color.fromRGBO(255, 207, 102, 1),
  c1l: Color.fromRGBO(253, 236, 236, 1),
  c2l: Color.fromRGBO(234, 244, 244, 1),
  c3l: Color.fromRGBO(255, 245, 223, 1),
);

//themetwo

final themetwo = AppTheme(
    name: 'princess peach',
    c1: Color.fromRGBO(238, 109, 109, 1),
    c2: Color.fromRGBO(248, 160, 119, 1),
    c3: Color.fromRGBO(255, 190, 133, 1),
    c1l: Color.fromRGBO(249, 203, 200, 1),
    c2l: Color.fromRGBO(252, 212, 197, 1),
    c3l: Color.fromRGBO(255, 223, 194, 1));

final themethree = AppTheme(
    name: 'true blue',
    c1: Color.fromRGBO(49, 99, 196, 1),
    c2: Color.fromRGBO(0, 119, 182, 1),
    c3: Color.fromRGBO(0, 180, 216, 1),
    c1l: Color.fromRGBO(191, 207, 237, 1),
    c2l: Color.fromRGBO(235, 250, 255, 1),
    c3l: Color.fromRGBO(202, 239, 247, 1));

//theme in use
var apptheme = themeone;

//MISC CONSTANTS
const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
);

const logFormDecoration = InputDecoration(
    filled: true,
    border: InputBorder.none,
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white70, width: 3.0)));

const logTime =
    BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)));
const logOption =
    BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)));

final Shader linearGradient = LinearGradient(
  colors: <Color>[
    Color.fromRGBO(223, 111, 111, 1),
    Color.fromRGBO(255, 207, 102, 1)
  ],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

final Shader linearGradient2 = LinearGradient(
  colors: <Color>[
    Color.fromRGBO(0, 131, 202, 1),
    Color.fromRGBO(0, 194, 203, 1)
  ],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
