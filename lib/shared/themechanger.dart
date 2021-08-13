import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:qdfitness/shared/theme_button.dart';
import 'package:qdfitness/shared/theme_values.dart';

class ThemeChanger extends StatefulWidget {
  ThemeChanger();

  @override
  _ThemeChangerState createState() => _ThemeChangerState();
}

class _ThemeChangerState extends State<ThemeChanger> {
  // Randomise the custom theme on the first load
  ThemeData _customTheme = ThemeData(
      primaryColor:
          Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
      accentColor:
          Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
      backgroundColor:
          Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 8),
            _themeColorContainer(
                "Primary Color", Theme.of(context).primaryColor),
            _themeColorContainer("Accent Color", Theme.of(context).accentColor),

            //given themes
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Choose a Theme",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ThemeButton(buttonThemeData: inkTheme),
                ThemeButton(buttonThemeData: spookyTheme),
                ThemeButton(buttonThemeData: pinkTheme),
              ],
            ),
            Spacer(),
            Text(
              "Select Custom Theme",
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 24),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      flex: 5,
                      child: ThemeButton(buttonThemeData: _customTheme)),
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Container(
                            width: double.infinity,
                            child: TextButton(
                                onPressed: () => _openDialog("Primary Color",
                                    _customTheme.primaryColor, true, false),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        _customTheme.primaryColor)),
                                child: Text("Choose Primary Color",
                                    textAlign: TextAlign.center,
                                    style:
                                        _customTheme.primaryTextTheme.button)),
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          flex: 5,
                          child: Container(
                            width: double.infinity,
                            child: TextButton(
                                onPressed: () => _openDialog("Accent Color",
                                    _customTheme.accentColor, false, true),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        _customTheme.accentColor)),
                                child: Text("Accent",
                                    textAlign: TextAlign.center,
                                    style:
                                        _customTheme.primaryTextTheme.button)),
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          flex: 5,
                          child: Container(
                            width: double.infinity,
                            child: TextButton(
                                onPressed: () => _openDialog("Background Color",
                                    _customTheme.backgroundColor, false, false),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        _customTheme.backgroundColor)),
                                child: Text("Background",
                                    textAlign: TextAlign.center,
                                    style:
                                        _customTheme.primaryTextTheme.button)),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  // Returns simple container to display what color the theme is currently using.
  Widget _themeColorContainer(String colorName, Color color) {
    return Container(
      width: double.infinity,
      height: 50,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 4),
      color: color,
      child: Text(colorName,
          textAlign: TextAlign.center,
          style: Theme.of(context).primaryTextTheme.button),
    );
  }

  // Dialog to select colors for theme.
  void _openDialog(
      String title, Color currentColor, bool primaryColor, bool accentColor) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: Container(
            height: 250,
            child: MaterialColorPicker(
              selectedColor: currentColor,
              onColorChange: (color) =>
                  setState(() => _customTheme = (primaryColor)
                      ? _customTheme.copyWith(primaryColor: color)
                      : (accentColor)
                          ? _customTheme.copyWith(accentColor: color)
                          : _customTheme.copyWith(backgroundColor: color)),
              onMainColorChange: (color) =>
                  setState(() => _customTheme = (primaryColor)
                      ? _customTheme.copyWith(primaryColor: color)
                      : (accentColor)
                          ? _customTheme.copyWith(accentColor: color)
                          : _customTheme.copyWith(backgroundColor: color)),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Done",
                style: Theme.of(context).textTheme.button,
              ),
            )
          ],
        );
      },
    );
  }
}
