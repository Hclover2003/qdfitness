import 'package:qdfitness/shared/theme_values.dart';
import 'package:flutter/material.dart';

class ThemeNotifier with ChangeNotifier {
  //default theme is inkTheme
  ThemeData _themeData = inkTheme;
  ThemeNotifier(this._themeData);

  //gets current theme
  getTheme() => _themeData;

  //sets theme with new theme, tells listeners
  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }
}
