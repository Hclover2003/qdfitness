import 'package:flutter/material.dart';
import 'package:qdfitness/screens/home/logfood2.dart';

class LogFood extends StatefulWidget {
  @override
  _LogFoodState createState() => _LogFoodState();
}

class _LogFoodState extends State<LogFood> {
  bool logFood = true;
  void toggleFoodView() {
    setState(() => logFood = !logFood);
  }

  @override
  Widget build(BuildContext context) {
    return logFood
        ? LogFood2(
            toggleView: toggleFoodView,
          )
        : Column(
            children: [
              Center(
                  child: Text(
                "543 Cal",
                style: Theme.of(context).textTheme.headline4,
              )),
              Flexible(
                child: SizedBox(
                    height: MediaQuery.of(context).size.longestSide * 0.5,
                    child: ListView.builder(itemBuilder: (context, i) {
                      return ListTile(
                        leading: Text("1x"),
                        title: Center(child: Text("bagel")),
                        trailing: Text("23 cal"),
                      );
                    })),
              ),
              ElevatedButton(
                  onPressed: () => setState(() {
                        toggleFoodView();
                      }),
                  child: Text("+"))
            ],
          );
  }
}
