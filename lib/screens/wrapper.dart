import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; //material
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:qdfitness/screens/authentication/authentication.dart'; //screens
import 'package:qdfitness/screens/home/apppage.dart';
import 'package:qdfitness/models/appuser.dart'; //models
import 'package:qdfitness/services/database.dart'; //services

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Returns user every login/logout
    final user = Provider.of<User>(context);

    //Returns Home/Auth widget
    if (user == null) {
      return Authenticate();
    } else {
      //Stream #2: UserData(name, weight, height, age)
      return StreamProvider<UserData>.value(
        initialData:
            UserData(uid: '0', name: "guest", createdAt: Timestamp.now()),
        value: DatabaseService(uid: user.uid).userData,
        child: AppPage(),
      );
    }
  }
}
