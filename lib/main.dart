import 'package:flutter/material.dart'; //material
import 'package:provider/provider.dart'; //provider
import 'package:firebase_auth/firebase_auth.dart'; //firebase auth
import 'package:firebase_core/firebase_core.dart'; //firebase core

import 'package:qdfitness/services/auth.dart'; //code: auth
import 'package:qdfitness/screens/wrapper.dart'; //code: wrapper
import 'package:qdfitness/shared/theme_notifier.dart'; //code: themenotifier
import 'package:qdfitness/shared/theme_values.dart'; //code: theme values
import 'package:qdfitness/firebase_options.dart'; //code: firebase

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Listens to ThemeNotifier(methods: getTheme, setTheme)
  runApp(ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(inkTheme), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    //Stream #1: default firebase User(email, uid, verified, etc.)
    return StreamProvider<User>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        theme: themeNotifier.getTheme(),
        home: Wrapper(),
      ),
    );
  }
}
