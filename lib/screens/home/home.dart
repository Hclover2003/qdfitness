import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/models/food.dart';
import 'package:qdfitness/screens/menu/aboutus.dart';
import 'package:qdfitness/services/database.dart';
import 'package:qdfitness/shared/extensions.dart';

class Home extends StatefulWidget {
  const Home({
    Key key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DailySummary todaySummary;
  List<DailySummary> recentSummaries;
  @override
  Widget build(BuildContext context) {
    final userdata = Provider.of<UserData>(context);
    final DatabaseService _db = DatabaseService(uid: userdata.uid);
    final dailysummaries = Provider.of<List<DailySummary>>(context);

//create new dailysummary for today if doesn't exist; else, fetch it
    if (dailysummaries == null) {
      print("loading...");
    } else if (dailysummaries.length == 0) {
      print("no summaries");
      _db.createNewSummary();
    } else {
      print(dailysummaries);
      var todaysum = dailysummaries.firstWhere(
          (x) =>
              (x.date.day == DateTime.now().day) &&
              (x.date.month == DateTime.now().month) &&
              (x.date.year == DateTime.now().year),
          orElse: () => null);

      if (todaysum == null) {
        print("no summary for today");
        _db.createNewSummary();

        var todaysum = dailysummaries.where((x) =>
            (x.date.day == DateTime.now().day) &&
            (x.date.month == DateTime.now().month) &&
            (x.date.year == DateTime.now().year));
      } else {
        print("today summary exists: $todaySummary");
        setState(() {
          todaySummary = todaysum;
        });
      }
    }

    double metabolism = userdata.weight != null
        ? (-1) *
            (447.593 +
                (0.246 * userdata.weight) +
                (3.098 * userdata.height) -
                (4.33 * userdata.age.toDouble()))
        : 14;
    // String currenttime = DateFormat.jm().format(DateTime.now());
    // String currentdate = DateFormat.yMMMMEEEEd().format(now);

    return Stack(children: [
      Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/imgs.png"),
                fit: BoxFit.cover)),
      ),
      Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: Column(
            children: [
              //TODO: jump to edit page on button click
              //TODO: change age, target weight, metabolism
              Subtitle(text: 'Hello ${userdata.name.capitalize()} !'),
              SummaryRow(
                name: "Food",
                cal: todaySummary.food,
                icon: Icons.add,
              ),
              SummaryRow(
                name: "Exercise",
                cal: todaySummary.exercise,
                icon: Icons.add,
              ),
              SummaryRow(
                name: "Metabolism",
                cal: metabolism.round(),
                icon: Icons.edit,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Total",
                    style: Theme.of(context).textTheme.headline5,
                  )),
                  Expanded(
                      child: Text(
                    "hello",
                    style: Theme.of(context).textTheme.headline4,
                  ))
                ],
              ),
              //TODO: Pie chart of different foodgroup percentages for today
              //TODO: Line graph of trend for last 7 days
            ],
          ),
        ),
      ),
    ]);
  }
}

class SummaryRow extends StatelessWidget {
  final String name;
  final int cal;
  final IconData icon;

  SummaryRow({this.name, this.cal, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(child: Text(name)),
          Expanded(child: Text(cal.toString())),
          Expanded(child: Icon(icon))
        ],
      ),
    );
  }
}
