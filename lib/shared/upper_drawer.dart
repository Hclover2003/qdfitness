import 'package:flutter/material.dart';
import 'package:qdfitness/screens/home/settings.dart';
import 'package:qdfitness/screens/menu/aboutus.dart';
import 'package:qdfitness/services/auth.dart';
import 'package:qdfitness/shared/themechanger.dart';

class UpperDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .copyWith(canvasColor: Theme.of(context).backgroundColor),
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'QDFitness',
                style: Theme.of(context).textTheme.headline3.copyWith(
                    fontFamily: "GlacialIndifference",
                    color: Theme.of(context).backgroundColor),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              title: Text('about us'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutUs()));
              },
            ),
            ListTile(
              title: Text('settings'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Settings()));
              },
            ),
            ListTile(
              title: Text('theme'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ThemeChanger()));
              },
            ),
            ListTile(
              title: Text('logout'),
              onTap: () {
                showAlertDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  final AuthService _auth = AuthService();

  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text("Yes"),
    onPressed: () async {
      await _auth.signOut();
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Logout"),
    content: Text("Are you sure you want to log out?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
