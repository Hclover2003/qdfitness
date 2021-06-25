import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  final String imgurl;
  ImageDialog({this.imgurl});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 200,
        decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
                image: NetworkImage(imgurl), fit: BoxFit.contain)),
      ),
    );
  }
}
