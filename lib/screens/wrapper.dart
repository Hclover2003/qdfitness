import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/screens/authentication/authentication.dart';
import 'package:qdfitness/screens/home/apppage.dart';
import 'package:provider/provider.dart';
import 'package:qdfitness/services/database.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //user is local variable; everytime user login/out, returns user data
    final user = Provider.of<AppUser>(context);
    print("----------------------USER INFO HERE----------------------");

    print(user);

    //return either Home or Auth widget
    if (user == null) {
      return Authenticate();
    } else {
      return StreamProvider<UserData>.value(
        initialData: UserData(
            uid: '0',
            name: 'guest',
            createdAt: Timestamp.now(),
            dailyExercise: 0,
            dailyFood: 0),
        value: DatabaseService(uid: user.uid).userData,
        child: AppPage(),
      );
    }
  }
}
