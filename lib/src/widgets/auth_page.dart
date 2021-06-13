import 'package:flutter/material.dart';
import 'package:ignite/src/providers/authentication_provider.dart';
import 'package:ignite/src/widgets/dashboard_page.dart';
import 'package:ignite/src/widgets/intro_page.dart';
import 'package:ignite/src/widgets/sign_in_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  AuthenticationProvider _authenticationProvider;
  bool _firstSeen = false;

  _checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstSeen = prefs.getBool("first_launch") ?? false;
    });
    await prefs.setBool("first_launch", true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authenticationProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
    _checkFirstSeen();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, value, widget) {
        if (!_firstSeen && value.currentUser == null) return IntroPage();
        if (value.currentUser == null) return SignInPage();
        return DashboardPage();
      },
    );
  }
}
