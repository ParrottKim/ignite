import 'package:flutter/cupertino.dart';
import 'package:ignite/models/lol.dart';
import 'package:ignite/src/repositories/lol_repository.dart';

class LOLProfileProvider extends ChangeNotifier {
  LOLRepository _lolRepository = LOLRepository();
  LOLUser _lolUser;
  LOLUser get lolUser => _lolUser;

  loadUserProfile(String username) async {
    _lolUser = await _lolRepository.getUserName(username);
    notifyListeners();
  }

  clearUserProfile() {
    _lolUser = null;
  }
}
