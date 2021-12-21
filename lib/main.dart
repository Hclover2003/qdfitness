import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/services/auth.dart';
import 'package:qdfitness/screens/wrapper.dart';
import 'package:qdfitness/shared/theme_notifier.dart';
import 'package:qdfitness/shared/theme_values.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(inkTheme), child: MyApp()));
}

//root widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //get theme with themenotifier
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    
    //appuser is the type of data we are listening to, user is the variable name of the stream
    return StreamProvider<AppUser>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        theme: themeNotifier.getTheme(),
        home: Wrapper(),
      ),
    );
  }
}
