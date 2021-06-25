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
                image: AssetImage("assets/images/backg1.png"),
                fit: BoxFit.cover)),
      ),
      Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: Column(children: [
            Subtitle(text: 'Hello ${userdata.name.capitalize()} !'),
            Padding(
              padding: EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/avatar1.png'),
                radius: 80,
              ),
            ),
            Container(
              height: 80,
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                      "Life is like riding a bicycle. To keep your balance, you must keep moving.",
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Theme.of(context).backgroundColor,
                          fontStyle: FontStyle.italic)),
                ),
              ),
            ),
            Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 5,
                        child: Container(
                          child: Text(
                            currenttime,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                .copyWith(
                                    color: Theme.of(context).primaryColor),
                          ),
                        )),
                    Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: Text(
                                      "Days Joined",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                    ),
                                  )),
                              Expanded(
                                  flex: 3,
                                  child: Container(
                                    child: Text(
                                      "56",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                    ),
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: Text(
                                      "Items Logged",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                    ),
                                  )),
                              Expanded(
                                  flex: 3,
                                  child: Container(
                                    child: Text(
                                      "1028",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                    ),
                                  )),
                            ],
                          ),
                        ))
                  ],
                )),
            Spacer()
          ]),
        ),
      ),
    ]);
  }
}
