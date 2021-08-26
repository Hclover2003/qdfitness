import 'package:flutter/material.dart';
import 'package:qdfitness/models/themes.dart';
import 'package:qdfitness/screens/menu/aboutus.dart';
import 'package:qdfitness/shared/shared.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  AppTheme chosentheme = themeone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("settings"),
        ),
        body: Column(
          children: [
            Subtitle(
              text: "change theme",
            ),
            Card(
              child: InkWell(
                child: ThemeRow(
                  theme: themeone,
                ),
                onTap: () {
                  setState(() {
                    chosentheme = themeone;
                  });
                },
              ),
            ),
            Card(
              child: InkWell(
                child: ThemeRow(
                  theme: themetwo,
                ),
                onTap: () {
                  setState(() {
                    chosentheme = themetwo;
                  });
                },
              ),
            ),
            Card(
              child: InkWell(
                child: ThemeRow(
                  theme: themethree,
                ),
                onTap: () {
                  setState(() {
                    chosentheme = themethree;
                  });
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Subtitle(
              text: 'change font',
            ),
            Card(
              child: ListTile(
                title: Center(child: Text('Glacial Indifference')),
              ),
            ),
            Card(
              child: ListTile(
                title: Center(child: Text('Times New Roman')),
              ),
            ),
            Card(
              child: ListTile(
                title: Center(child: Text('System Default')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.green[200],
                      borderRadius: BorderRadius.circular(40)),
                  child: TextButton(
                    onPressed: () {
                      print("theme");
                    },
                    child: Text(
                      "save",
                      style: TextStyle(fontSize: 20),
                    ),
                  )),
            )
          ],
        ));
  }
}

class ThemeRow extends StatelessWidget {
  final AppTheme theme;
  const ThemeRow({Key key, this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ColorCircle(
          colour: theme.c1,
        ),
        ColorCircle(
          colour: theme.c2,
        ),
        ColorCircle(
          colour: theme.c3,
        ),
      ],
    );
  }
}

class ColorCircle extends StatelessWidget {
  final Color colour;

  const ColorCircle({Key key, this.colour}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(color: colour, shape: BoxShape.circle),
    );
  }
}
