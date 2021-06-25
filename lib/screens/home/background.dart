import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  String imgurl;
  Background({this.imgurl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(imgurl), fit: BoxFit.cover)),
    );
  }
}
