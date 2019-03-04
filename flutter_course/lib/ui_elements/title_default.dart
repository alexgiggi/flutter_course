import 'package:flutter/material.dart';

class TitleDefault extends StatelessWidget{
  final String title;
  
  TitleDefault(this.title);

  @override
  Widget build(BuildContext context) {
    final deviceWidth =MediaQuery.of(context).size.width;

    return Text(title, style: TextStyle(fontSize: deviceWidth>700 ? 26 : 14, fontWeight: FontWeight.bold, fontFamily: 'Oswald'), softWrap: true, textAlign: TextAlign.center,);
  }

}
