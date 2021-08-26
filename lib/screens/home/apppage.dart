import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/models/food.dart';
import 'package:qdfitness/screens/home/apppagechild.dart';
import 'package:qdfitness/services/database.dart';

class AppPage extends StatefulWidget {
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    return StreamProvider<List<DailySummary>>.value(
        initialData: null,
        value: DatabaseService(uid: user.uid).dailysummaries,
        catchError: (_, __) => null,

        //exit keyboard focus when press elsewhere on screen
        child: AppPageChild());
  }
}
