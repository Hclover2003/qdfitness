import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/models/food.dart';
import 'package:qdfitness/screens/home/weekchart.dart';
import 'package:qdfitness/screens/menu/aboutus.dart';
import 'package:qdfitness/services/database.dart';
import 'package:qdfitness/shared/constantfns.dart';
import 'package:qdfitness/shared/extensions.dart';

//home page
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
  List<WeekData> weekdata;

  @override
  Widget build(BuildContext context) {
    final userdata = Provider.of<UserData>(context);
    final DatabaseService _db = DatabaseService(uid: userdata.uid);
    final dailysummaries = Provider.of<List<DailySummary>>(context);

    //FIXME: sometimes create new summary even if summary exists
    //check summaries, see if today summary exists. If not, create one
    if (dailysummaries == null) {
      if (DateTime.parse(userdata.createdAt.toDate().toString())
              .difference(DateTime.now())
              .inMinutes <
          1) {
        print("yay");
      } else {
        print("loading...");
      }
    } else if (dailysummaries.length == 0) {
      print("no summaries");
      _db.createNewSummary();
    } else {
      var todaysum = getTodaySummary(dailysummaries);
      if (todaysum == null) {
        print("no summary for today");
        _db.createNewSummary();
      } else {
        setState(() {
          todaySummary = todaysum;
        });
      }
    }
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
    double metabolism = userdata.weight != null
        ? (-1) *
            (447.593 +
                (0.246 * userdata.weight) +
                (3.098 * userdata.height) -
                (4.33 * userdata.age.toDouble()))
        : 14;
    // String currenttime = DateFormat.jm().format(DateTime.now());
    // String currentdate = DateFormat.yMMMMEEEEd().format(now);

    //return loading if fetching today's summary
    return (todaySummary == null)
        //FIXME: better loading screen
        ? Text("Loading...")
        : SingleChildScrollView(
            child: Stack(children: [
              //FIXME: better background image
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
                      //TODO: change age, height, weight, gender (used to calculate BMR)
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
                        name: "Current Goal",
                        cal: metabolism.round(),
                        icon: Icons.edit,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Total",
                              style: Theme.of(context).textTheme.headline5,
                            )),
                            Expanded(
                                child: Text(
                              (todaySummary.food + todaySummary.exercise)
                                  .toString(),
                              style: Theme.of(context).textTheme.headline4,
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
                      TextButton(onPressed: () {}, child: Text("More..."))
                      //TODO: Pie chart of different foodgroup percentages for today
                    ],
                  ),
                ),
              ),
            ]),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: Text(name)),
          Expanded(child: Center(child: Text(cal.toString()))),
          Expanded(
              child: IconButton(
            icon: Icon(icon),
            onPressed: () {
              print("metabolism edit...");
            },
          ))
        ],
      ),
    );
  }
}
