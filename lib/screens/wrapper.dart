import 'package:flutter/material.dart';
import 'package:qdfitness/models/appuser.dart';
import 'package:qdfitness/screens/authentication/authentication.dart';
import 'package:qdfitness/screens/home/apppage.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //user is local variable; everytime user login/out, returns user data
    final user = Provider.of<AppUser>(context);

    //return either Home or Auth widget
    if (user == null) {
      return Authenticate();
    } else {
      return AppPage();
    }
  }
}
