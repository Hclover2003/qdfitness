import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qdfitness/screens/home/apppagechild.dart';
import 'package:qdfitness/models/food.dart';
import 'package:qdfitness/services/database.dart';

class AppPage extends StatefulWidget {
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    //Stream #3: List of DailySummaries for user
    return StreamProvider<List<DailySummary>>.value(
        initialData: [],
        value: DatabaseService(uid: user.uid).dailysummaries,
        catchError: (_, __) => null,
        child: AppPageChild());
  }
}
