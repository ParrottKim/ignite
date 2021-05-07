import 'package:flutter/material.dart';
import 'package:ignite/src/providers/authentication_provider.dart';
import 'package:ignite/src/widgets/dashboard_page.dart';
import 'package:ignite/src/widgets/intro_page.dart';
import 'package:ignite/src/widgets/sign_in_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatelessWidget {
  AuthPage({Key key}) : super(key: key);
  AuthenticationProvider _authenticationProvider;

  Future<bool> checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool("first_launch") ?? false);

    if (_seen)
      return true;
    else
      await prefs.setBool("first_launch", true);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    _authenticationProvider = Provider.of<AuthenticationProvider>(context);
    return FutureBuilder(
      future: checkFirstSeen(),
      builder: (context, snapshot) {
        print(_authenticationProvider.userState);
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        else if (snapshot.data) {
          if (_authenticationProvider.userState != null) {
            return DashboardPage();
          }
          return SignInPage();
        } else
          return IntroPage();
      },
    );
  }
}
