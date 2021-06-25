import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/screens/home/diary.dart';
import 'package:qdfitness/screens/home/home.dart';
import 'package:qdfitness/screens/home/log.dart';
import 'package:qdfitness/services/database.dart';
import '../../shared/shared.dart';

class AppPage extends StatefulWidget {
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  int i = 0;
  var pages = [Home(), Log(), Diary()];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    return StreamProvider<UserData>.value(
      initialData: UserData(uid: '0', name: 'guest'),
      value: DatabaseService(uid: user.uid).userData,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        //don't resize with onscreen keyboard
        resizeToAvoidBottomInset: false,

        //appbar
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          iconTheme: IconThemeData(color: Theme.of(context).accentColor),
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
                    FontAwesomeIcons.featherAlt,
                    size: 20,
                  ),
                  label: 'log'),
              BottomNavigationBarItem(
                  icon: Icon(
                    FontAwesomeIcons.calendarAlt,
                    size: 20,
                  ),
                  label: 'diary'),
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
