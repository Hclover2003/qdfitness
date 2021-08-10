import 'package:flutter/material.dart';
import 'package:qdfitness/screens/home/logfood.dart';

class ShowMenu extends StatefulWidget {
  @override
  _ShowMenuState createState() => _ShowMenuState();
}

class _ShowMenuState extends State<ShowMenu> {
  bool logFood = true;
  void toggleFoodView() {
    setState(() => logFood = !logFood);
  }

  @override
  Widget build(BuildContext context) {
    return logFood
        ? LogFood()
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
