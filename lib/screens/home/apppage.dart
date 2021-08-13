import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/screens/home/home.dart';
import 'package:qdfitness/screens/home/logexercise.dart';
import 'package:qdfitness/screens/home/logfood.dart';
import 'package:qdfitness/services/database.dart';
import 'package:qdfitness/shared/theme_notifier.dart';
import '../../shared/shared.dart';

class AppPage extends StatefulWidget {
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  int i = 0;
  var pages = [Home(), LogFood(), LogExercise()];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return StreamProvider<UserData>.value(
      initialData: UserData(
          uid: '0',
          name: 'guest',
          createdAt: Timestamp.now(),
          dailyExercise: 0,
          dailyFood: 0),
      value: DatabaseService(uid: user.uid).userData,
      //exit keyboard focus when press elsewhere on screen
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          //don't resize with onscreen keyboard
          resizeToAvoidBottomInset: false,

          //appbar
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

          //side menu
          drawer: UpperDrawer(),

          //bottom options
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
      ),
    );
  }
}
