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
  //Different screens
  int i = 0;
  var pages = [Home(), LogFood(), LogExercise()];

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return GestureDetector(
      //Exists keyboard focus on outside tap
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          iconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.secondary),
          actions: [
            //Change to Dark Mode
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: IconButton(
                onPressed: () {
                  final tmpP = Theme.of(context).backgroundColor;
                  final tmpA = Theme.of(context).primaryColor;
                  themeNotifier.setTheme(ThemeData(
                      primaryColor: tmpP,
                      backgroundColor: tmpA,
                      accentColor: Theme.of(context).accentColor));
                },
                icon: Icon(Icons.lightbulb),
              ),
            ), Padding(padding: const EdgeInsets.fromLTRB(0, 0, 10, 0), child: IconButton(onPressed: (){}, icon: Icon(Icons.question_mark),),)
          ],
        ),
        drawer: UpperDrawer(),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Theme.of(context).colorScheme.secondary,
            primaryColor: Theme.of(context).backgroundColor,
          ),
          child: BottomNavigationBar(
            selectedItemColor: Theme.of(context).primaryColor,
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
