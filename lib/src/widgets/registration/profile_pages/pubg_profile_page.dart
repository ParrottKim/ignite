import 'package:flutter/material.dart';

class PUBGProfilePage extends StatefulWidget {
  PUBGProfilePage({Key key}) : super(key: key);

  @override
  _PUBGProfilePageState createState() => _PUBGProfilePageState();
}

class _PUBGProfilePageState extends State<PUBGProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(title: Text("Playerunknown's Battlegrounds"))),
    );
  }
}
