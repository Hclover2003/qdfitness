import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/screens/wrapper.dart';
import 'package:qdfitness/services/auth.dart';
import 'package:provider/provider.dart';

//main function
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

//root widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //appuser is the type of data we are listening to
    return StreamProvider<AppUser>.value(
      //user is the variable name of the stream
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(
            fontFamily: 'GlacialIndifference',
            primaryColor: Color.fromRGBO(106, 153, 78, 1),
            accentColor: Color.fromRGBO(188, 71, 73, 1),
            backgroundColor: Color.fromRGBO(242, 232, 207, 1),
            textTheme: TextTheme(
                headline1: TextStyle(
                    fontSize: 24.0,
                    fontFamily: 'roboto',
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold))),
        home: Wrapper(),
      ),
    );
  }
}
