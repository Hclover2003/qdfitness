import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:intl/intl.dart';
import 'package:qdfitness/screens/menu/aboutus.dart';
import 'package:qdfitness/shared/extensions.dart';

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
                image: AssetImage("assets/images/imgs.png"),
                fit: BoxFit.cover)),
      ),
      Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: Column(
            children: [
              Subtitle(text: 'Hello ${userdata.name.capitalize()} !'),
              SummaryRow(
                name: "Food",
                cal: '159',
                icon: Icons.add,
              ),
              SummaryRow(
                name: "Exercise",
                cal: '-12',
                icon: Icons.add,
              ),
              SummaryRow(
                name: "Metabolism",
                cal: '-59',
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
                    "129 cal",
                    style: Theme.of(context).textTheme.headline4,
                  ))
                ],
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}

class SummaryRow extends StatelessWidget {
  final String name;
  final String cal;
  final IconData icon;

  SummaryRow({this.name, this.cal, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(child: Text(name)),
          Expanded(child: Text(cal)),
          Expanded(child: Icon(icon))
        ],
      ),
    );
  }
}
