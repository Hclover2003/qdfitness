import 'package:flutter/material.dart';
import 'package:qdfitness/models/themes.dart';

final List foodchoices = [
  {"group": "grain", "name": "steamed bun", "calories": 218, "unit": "100g"},
  {"group": "grain", "name": "english muffin", "calories": 235, "unit": "100g"},
  {
    "group": "grain",
    "name": "whole wheat bread",
    "calories": 247,
    "unit": "100g"
  },
  {"group": "grain", "name": "white bread", "calories": 265, "unit": "100g"},
  {"group": "grain", "name": "sweet bread", "calories": 310, "unit": "100g"},
  {"group": "grain", "name": "oatmeal", "calories": 68, "unit": "100g"},
  {
    "group": "grain",
    "name": "spaghetti/noodles",
    "calories": 135,
    "unit": "100g"
  },
  {
    "group": "grain",
    "name": "instant noodles",
    "calories": 450,
    "unit": "100g"
  },
  {
    "group": "grain",
    "name": "macaroni & cheese, spaghetti and eatballs",
    "calories": 164,
    "unit": "100g"
  },
  {"group": "grain", "name": "pizza", "calories": 266, "unit": "100g"},
  {"group": "grain", "name": "sticky rice", "calories": 97, "unit": "100g"},
  {"group": "grain", "name": "brown rice", "calories": 111, "unit": "100g"},
  {"group": "grain", "name": "white rice", "calories": 130, "unit": "100g"},
  {"group": "grain", "name": "pancakes", "calories": 227, "unit": "100g"},
  {"group": "grain", "name": "purple rice", "calories": 150, "unit": "100g"},
  {"group": "fruits", "name": "strawberries", "calories": 33, "unit": "100g"},
  {"group": "fruits", "name": "blackberries", "calories": 43, "unit": "100g"},
  {"group": "fruits", "name": "mulberries", "calories": 43, "unit": "100g"},
  {"group": "fruits", "name": "raspberries", "calories": 53, "unit": "100g"},
  {"group": "fruits", "name": "blueberries", "calories": 57, "unit": "100g"},
  {"group": "fruits", "name": "kiwi", "calories": 61, "unit": "100g"},
  {"group": "fruits", "name": "grapes", "calories": 67, "unit": "100g"},
  {"group": "fruits", "name": "watermelon", "calories": 30, "unit": "100g"},
  {"group": "fruits", "name": "cantaloupe", "calories": 34, "unit": "100g"},
  {"group": "fruits", "name": "honeydew", "calories": 36, "unit": "100g"},
  {"group": "fruits", "name": "orange", "calories": 47, "unit": "100g"},
  {"group": "fruits", "name": "tomato", "calories": 22, "unit": "100g"},
  {"group": "fruits", "name": "avocado", "calories": 160, "unit": "100g"},
  {"group": "fruits", "name": "apple", "calories": 52, "unit": "100g"},
  {"group": "fruits", "name": "pear", "calories": 57, "unit": "100g"},
  {"group": "fruits", "name": "peaches", "calories": 39, "unit": "100g"},
  {"group": "fruits", "name": "apricot", "calories": 46, "unit": "100g"},
  {"group": "fruits", "name": "plum", "calories": 48, "unit": "100g"},
  {"group": "fruits", "name": "cherries", "calories": 50, "unit": "100g"},
  {"group": "fruits", "name": "papaya", "calories": 43, "unit": "100g"},
  {"group": "fruits", "name": "pineapple", "calories": 50, "unit": "100g"},
  {"group": "fruits", "name": "mango", "calories": 60, "unit": "100g"},
  {"group": "fruits", "name": "lychee", "calories": 66, "unit": "100g"},
  {"group": "fruits", "name": "guava", "calories": 68, "unit": "100g"},
  {"group": "fruits", "name": "banana", "calories": 89, "unit": "100g"},
  {"group": "vegetables", "name": "garlic", "calories": 3, "unit": "1 clove"},
  {"group": "vegetables", "name": "onion", "calories": 40, "unit": "100g"},
  {
    "group": "vegetables",
    "name": "cauliflower",
    "calories": 25,
    "unit": "100g"
  },
  {"group": "vegetables", "name": "broccoli", "calories": 34, "unit": "100g"},
  {"group": "vegetables", "name": "cucumber", "calories": 15, "unit": "100g"},
  {
    "group": "vegetables",
    "name": "bitter melon",
    "calories": 19,
    "unit": "100g"
  },
  {"group": "vegetables", "name": "eggplants", "calories": 25, "unit": "100g"},
  {"group": "vegetables", "name": "jalapeno", "calories": 28, "unit": "100g"},
  {
    "group": "vegetables",
    "name": "sweet bell peppers",
    "calories": 31,
    "unit": "100g"
  },
  {"group": "vegetables", "name": "okra", "calories": 33, "unit": "100g"},
  {
    "group": "vegetables",
    "name": "chili peppers",
    "calories": 40,
    "unit": "100g"
  },
  {"group": "vegetables", "name": "squash", "calories": 40, "unit": "100g"},
  {"group": "vegetables", "name": "artichoke", "calories": 47, "unit": "100g"},
  {
    "group": "vegetables",
    "name": "black fungus",
    "calories": 20,
    "unit": "100g"
  },
  {"group": "vegetables", "name": "mushrooms", "calories": 22, "unit": "100g"},
  {"group": "vegetables", "name": "watercress", "calories": 11, "unit": "100g"},
  {"group": "vegetables", "name": "napa", "calories": 12, "unit": "100g"},
  {"group": "vegetables", "name": "bok choy", "calories": 13, "unit": "100g"},
  {"group": "vegetables", "name": "lettuce", "calories": 15, "unit": "100g"},
  {"group": "vegetables", "name": "spinach", "calories": 23, "unit": "100g"},
  {"group": "vegetables", "name": "yu choy", "calories": 24, "unit": "100g"},
  {"group": "vegetables", "name": "cabbage", "calories": 25, "unit": "100g"},
  {"group": "vegetables", "name": "kale", "calories": 28, "unit": "100g"},
  {
    "group": "vegetables",
    "name": "shepherd's purse",
    "calories": 31,
    "unit": "100g"
  },
  {"group": "vegetables", "name": "pea shoots", "calories": 31, "unit": "100g"},
  {"group": "vegetables", "name": "radishes", "calories": 16, "unit": "100g"},
  {"group": "vegetables", "name": "turnip", "calories": 28, "unit": "100g"},
  {"group": "vegetables", "name": "carrots", "calories": 41, "unit": "100g"},
  {"group": "vegetables", "name": "ginger", "calories": 80, "unit": "100g"},
  {"group": "vegetables", "name": "peas/beans", "calories": 81, "unit": "100g"},
  {"group": "vegetables", "name": "corn", "calories": 96, "unit": "100g"},
  {"group": "vegetables", "name": "celery", "calories": 16, "unit": "100g"},
  {"group": "vegetables", "name": "asparagus", "calories": 20, "unit": "100g"},
  {"group": "vegetables", "name": "potatoes", "calories": 77, "unit": "100g"},
  {
    "group": "vegetables",
    "name": "sweet potatoes",
    "calories": 86,
    "unit": "100g"
  },
  {"group": "vegetables", "name": "taro", "calories": 142, "unit": "100g"},
  {"group": "protein", "name": "lean", "calories": 143, "unit": "1 slice"},
  {"group": "protein", "name": "medium", "calories": 242, "unit": "100g"},
  {"group": "protein", "name": "fatty", "calories": 407, "unit": "100g"},
  {"group": "protein", "name": "salmon", "calories": 206, "unit": "100g"},
  {
    "group": "protein",
    "name": "lobster, squid, shrimp",
    "calories": 95,
    "unit": "100g"
  },
  {"group": "protein", "name": "mackerel", "calories": 262, "unit": "100g"},
  {"group": "protein", "name": "fish sticks", "calories": 290, "unit": "100g"},
  {"group": "protein", "name": "nuts", "calories": 607, "unit": "100g"}
];
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
