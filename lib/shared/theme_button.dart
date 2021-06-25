import 'package:qdfitness/shared/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeButton extends StatelessWidget {
  final ThemeData buttonThemeData;

  ThemeButton({this.buttonThemeData});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return RawMaterialButton(
      //onpressed change theme
      onPressed: () {
        themeNotifier.setTheme(buttonThemeData);
      },

      //animated switch from x to checkmark
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 400),
        transitionBuilder: (Widget child, Animation<double> animation) =>
            ScaleTransition(
          child: child,
          scale: animation,
        ),
        child: _getIcon(themeNotifier),
      ),

      //circle shape
      shape: CircleBorder(
          side: BorderSide(color: buttonThemeData.backgroundColor, width: 3)),
      elevation: 2.0,

      //fill colour is primary colour
      fillColor: buttonThemeData.primaryColor,
      padding: const EdgeInsets.all(15.0),
    );
  }

//returns x or checkmark depending on whether current theme is same as btntheme
//icon color is accent color
  Widget _getIcon(ThemeNotifier themeNotifier) {
    bool selected = (themeNotifier.getTheme() == buttonThemeData);

    return Container(
      key: Key((selected) ? "ON" : "OFF"),
      child: Icon(
        (selected) ? Icons.done : Icons.close,
        color: buttonThemeData.accentColor,
        size: 20.0,
      ),
    );
  }
}
