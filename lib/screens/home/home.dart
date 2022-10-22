import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/models/food.dart';
import 'package:qdfitness/services/database.dart';
import 'package:qdfitness/shared/constantfns.dart';
import 'package:qdfitness/shared/extensions.dart';
import 'package:qdfitness/screens/home/weekchart.dart';
import 'package:qdfitness/screens/menu/aboutus.dart';

//Homepage: Displays summary for day and week
class Home extends StatefulWidget {
  const Home({
    Key key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  /// todaySummary: dailysummary for today
  // recentSummaries: list of dailysummaries for past 7 days
  // weekdata: list of (date, food, exercise) for weekchart

  DailySummary todaySummary;
  List<DailySummary> recentSummaries;
  List<WeekData> weekdata;

  @override
  Widget build(BuildContext context) {
    final userdata = Provider.of<UserData>(context);
    final DatabaseService _db = DatabaseService(uid: userdata.uid);
    final dailysummaries = Provider.of<List<DailySummary>>(context);

    //Create and/or get today's summary
    if (dailysummaries == null) {
      print("loading...");
    } else {
      final todaysum = getTodaySummary(dailysummaries);
      if (todaysum == null) {
        print("no summary for today yet");
        _db.createNewSummary();
      } else {
        setState(() {
          todaySummary = todaysum;
        });
      }
    }

    //Get recent summaries for week
    dailysummaries.sort((b, a) => a.date.compareTo(b.date));
    var weekago = DateTime.now().subtract(Duration(days: 7));
    setState(() {
      recentSummaries = dailysummaries
          .where((element) =>
              element.date.isAfter(weekago) &&
              element.date.isBefore(DateTime.now()))
          .toList();
      weekdata = recentSummaries
          .map((i) => WeekData(DateFormat('Md').format(i.date),
              i.food.toDouble(), i.exercise.toDouble()))
          .toList();
    });
    String gender = "F";
    double weight = 56.5;
    double height = 167;
    int age = 18;
    String activity = "sedentary";
    double activitylevel;
    switch (activity) {
      case "sedentary":
        activitylevel = 1.2;
        break;
      case "lightly active":
        activitylevel = 1.375;
        break;
      case "moderately active":
        activitylevel = 1.55;
        break;
      case "very active":
        activitylevel = 1.725;
        break;
    }
    double metabolism = gender == "F"
        ? (655 + (9.6 * weight) + (1.8 * height) - (4.7 * age)) * activitylevel
        : (66 + (13.7 * weight) + (5 * height) - (6.8 * age)) * activitylevel;

    //Return's loading if fetching summary
    return (todaySummary == null)
        //FIXME: better loading screen
        ? Text("Loading...")
        : SingleChildScrollView(
            child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Column(
                  children: [
                    //TODO: jump to edit page on button click
                    //TODO: change age, height, weight, gender (used to calculate BMR)
                    Subtitle(text: 'Hello ${userdata.name.capitalize()} !'),
                    SummaryRow(
                      name: "Food",
                      cal: todaySummary.food,
                      icon: Icons.add,
                    ),
                    SummaryRow(
                      name: "Exercise",
                      cal: -1 * todaySummary.exercise,
                      icon: Icons.add,
                    ),
                    SummaryRow(
                      name: "Current Goal",
                      cal: metabolism.round(),
                      icon: Icons.edit,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                              child: Text(
                            "Total",
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor),
                          )),
                          Expanded(
                              child: Text(
                            (todaySummary.food - todaySummary.exercise)
                                    .toString() +
                                " cal",
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor),
                          ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: WeekChart(
                        weekdata: weekdata.reversed.toList(),
                      ),
                    ),
                    TextButton(onPressed: () {}, child: Text("More")),
                    TextButton(onPressed: () {}, child: Text("Reset"))
                    //TODO: Pie chart of different foodgroup percentages for today; pop up menu with all dailysummaries
                  ],
                ),
              ),
            ),
          );
  }
}

//one row in home page
class SummaryRow extends StatelessWidget {
  final String name;
  final int cal;
  final IconData icon;

  SummaryRow({this.name, this.cal, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(name,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            Text(
              (cal.isNegative ? "- " : "+ ") + cal.abs().toString(),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.all(0),
              child: IconButton(
                icon: IconTheme(
                    data: IconThemeData(size: 30),
                    child: Icon(
                      icon,
                      color: Theme.of(context).primaryColor,
                    )),
                onPressed: () {
                  print("metabolism edit...");
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
