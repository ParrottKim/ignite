import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ignite/src/widgets/registration/profile_pages/lol_profile_page.dart';
import 'package:ignite/src/widgets/registration/profile_pages/pubg_profile_page.dart';

class ProfilePageProvider extends ChangeNotifier {
  getPage(String gameName) {
    switch (gameName) {
      case "League of Legends":
        return LOLProfilePage();
        break;
      case "Playerunknown's Battlegrounds":
        return new PUBGProfilePage();
        break;
      default:
        return new Scaffold(body: Center(child: Text(gameName)));
        break;
    }
  }
}
