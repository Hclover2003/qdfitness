import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:qdfitness/screens/home/home.dart';
import 'package:qdfitness/screens/home/logexercise.dart';
import 'package:qdfitness/screens/home/logfood.dart';
import 'package:qdfitness/shared/theme_notifier.dart';
import 'package:qdfitness/shared/upper_drawer.dart';

class AppPageChild extends StatefulWidget {
  @override
  _AppPageChildState createState() => _AppPageChildState();
}

class _AppPageChildState extends State<AppPageChild> {
  int i = 0;
  var pages = [Home(), LogFood(), LogExercise()];
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          iconTheme: IconThemeData(color: Theme.of(context).accentColor),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: IconButton(
                onPressed: () {
                  var tmpP = Theme.of(context).backgroundColor;
                  var tmpA = Theme.of(context).primaryColor;
                  themeNotifier.setTheme(Theme.of(context)
                      .copyWith(primaryColor: tmpP, backgroundColor: tmpA));
                },
                icon: Icon(Icons.lightbulb),
              ),
            )
          ],
        ),
        drawer: UpperDrawer(),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Theme.of(context).primaryColor,
              primaryColor: Theme.of(context).backgroundColor),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    FontAwesomeIcons.home,
                    size: 20,
                  ),
                  label: 'home'),
              BottomNavigationBarItem(
                  icon: Icon(
                    FontAwesomeIcons.utensils,
                    size: 20,
                  ),
                  label: 'food'),
              BottomNavigationBarItem(
                  icon: Icon(
                    FontAwesomeIcons.dumbbell,
                    size: 20,
                  ),
                  label: 'exercise'),
            ],
            currentIndex: i,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              setState(() {
                i = index;
              });
            },
          ),
        ),
        body: pages[i],
      ),
    );
  }
}
