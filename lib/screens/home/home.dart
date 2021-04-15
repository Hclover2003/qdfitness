import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:intl/intl.dart';
import 'package:qdfitness/shared/shared.dart';

class Home extends StatelessWidget {
  const Home({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userdata = Provider.of<UserData>(context);
    DateTime now = DateTime.now();
    String currenttime = DateFormat.jm().format(now);
    String currentdate = DateFormat.yMMMMEEEEd().format(now);

    return Stack(children: [
      Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/7.png"), fit: BoxFit.cover)),
      ),
      Center(
        child: Container(
          child: Column(children: [
            Text('welcome ${userdata.name} !'),
            Text('It is'),
            SizedBox(
              height: 20,
            ),
            Container(
                width: double.infinity,
                height: 150.0,
                decoration: BoxDecoration(color: apptheme.c2),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currenttime,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontFamily: 'GlacialIndifference'),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      currentdate,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'GlacialIndifference'),
                    ),
                  ],
                ))),
            SizedBox(
              height: 200,
            ),
            SizedBox(
                height: 60,
                width: 100,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'my goal',
                    style: TextStyle(color: Color.fromRGBO(255, 207, 102, 1)),
                  ),
                  style: TextButton.styleFrom(
                    primary: Color.fromRGBO(255, 207, 102, 1),
                    backgroundColor: Color.fromRGBO(255, 245, 223, 1),
                  ),
                ))
          ]),
        ),
      ),
    ]);
  }
}
