import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ignite/src/providers/authentication_provider.dart';
import 'package:ignite/src/providers/bottom_navigation_provider.dart';
import 'package:ignite/src/providers/lol_profile_provider.dart';
import 'package:ignite/src/providers/profile_page_provider.dart';
import 'package:ignite/src/widgets/auth_page.dart';
import 'package:ignite/theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: "Ignite",
    //   theme: MainTheme.lightTheme,
    //   home: MultiProvider(
    //     providers: [
    //       ChangeNotifierProvider(
    //           create: (_) => AuthenticationProvider(FirebaseAuth.instance)),
    //       ChangeNotifierProvider(create: (_) => BottomNavigationProvider()),
    //       ChangeNotifierProvider(create: (_) => ProfilePageProvider()),
    //       ChangeNotifierProvider(create: (_) => LOLProfileProvider()),
    //     ],
    //     child: AuthPage(),
    //   ),
    // );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AuthenticationProvider(FirebaseAuth.instance)),
        ChangeNotifierProvider(create: (_) => BottomNavigationProvider()),
        ChangeNotifierProvider(create: (_) => ProfilePageProvider()),
        ChangeNotifierProvider(create: (_) => LOLProfileProvider()),
      ],
      child: MaterialApp(
        title: "Ignite",
        theme: MainTheme.lightTheme,
        home: AuthPage(),
      ),
    );
  }
}
