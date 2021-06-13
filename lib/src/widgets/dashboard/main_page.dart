import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ignite/src/widgets/registration/registration_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;
  PageController _pageController;

  List<Widget> swiper = [
    Card(
      elevation: 1.0,
      semanticContainer: true,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Image.asset("assets/temp1.png",
              width: double.infinity, height: 240, fit: BoxFit.cover),
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              width: 300,
              color: Colors.black54,
              padding: EdgeInsets.all(10),
              child: Text(
                'I Like Potatoes And Oranges',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    ),
    Card(
      elevation: 1.0,
      semanticContainer: true,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Image.asset("assets/temp2.png",
              width: double.infinity, height: 240, fit: BoxFit.cover),
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              width: 300,
              color: Colors.black54,
              padding: EdgeInsets.all(10),
              child: Text(
                'I Like Potatoes And Oranges',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    ),
    Card(
      elevation: 1.0,
      semanticContainer: true,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Image.asset("assets/temp3.png",
              width: double.infinity, height: 240, fit: BoxFit.cover),
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              width: 300,
              color: Colors.black54,
              padding: EdgeInsets.all(10),
              child: Text(
                'I Like Potatoes And Oranges',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    ),
  ];

  _checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool("first_login") ?? false);

    if (!_seen) {
      await prefs.setBool("first_login", true);
      Navigator.pushAndRemoveUntil(
          context, _createRoute(RegistrationPage()), (_) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    _checkFirstSeen();
    _pageController = PageController(initialPage: _index);
    Timer.periodic(Duration(seconds: 4), (timer) {
      if (_index < 2)
        _index++;
      else
        _index = 0;

      if (_pageController.hasClients)
        _pageController.animateToPage(_index,
            duration: Duration(milliseconds: 200), curve: Curves.bounceInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("메인")),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("업데이트 소식",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.0),
            SizedBox(
              height: 240,
              child: PageView.builder(
                itemCount: 3,
                controller: _pageController,
                onPageChanged: (index) => setState(() => _index = index),
                itemBuilder: (context, index) {
                  return swiper[index];
                },
              ),
            ),
            SizedBox(height: 10.0),
            Divider(thickness: 0.4, height: 1.0),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  Route _createRoute(Widget route) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => route,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
