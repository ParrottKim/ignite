import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ignite/models/dropdown_item.dart';
import 'package:ignite/models/lol.dart';
import 'package:ignite/src/providers/authentication_provider.dart';
import 'package:ignite/src/providers/lol_profile_provider.dart';
import 'package:ignite/src/widgets/search/post_pages/lol_post_page.dart';
import 'package:provider/provider.dart';

class WritePostPage extends StatefulWidget {
  final AsyncSnapshot<dynamic> snapshot;
  WritePostPage({Key key, this.snapshot}) : super(key: key);

  @override
  _WritePostPageState createState() => _WritePostPageState();
}

class _WritePostPageState extends State<WritePostPage>
    with SingleTickerProviderStateMixin {
  AuthenticationProvider _authenticationProvider;
  LOLProfileProvider _lolProfileProvider;

  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  Map _images = Map<String, Image>();
  bool _imageLoaded = false;

  int _selectedIndex = 0;

  bool _isPreloaded = false;

  void changeRadioButtonIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future _refreshGameProfile() async {
    String accountName;
    switch (widget.snapshot.data.docs[_selectedIndex].id) {
      case "lol":
        await firestore
            .collection("user")
            .doc(_authenticationProvider.currentUser.uid)
            .collection("accounts")
            .doc(widget.snapshot.data.docs[_selectedIndex].id)
            .get()
            .then((element) {
          accountName = element.data()["name"];
        });
        print(accountName);

        await _lolProfileProvider.loadUserProfile(accountName);
        LOLUser lolUser = _lolProfileProvider.lolUser;

        await firestore
            .collection("user")
            .doc(_authenticationProvider.currentUser.uid)
            .collection("accounts")
            .doc("lol")
            .set({
          "id": lolUser.id,
          "name": lolUser.name,
          "profileIconId": lolUser.profileIconId,
          "summonerLevel": lolUser.summonerLevel,
          "soloTier": lolUser.soloTier,
          "soloRank": lolUser.soloRank,
          "soloLeaguePoints": lolUser.soloLeaguePoints,
          "flexTier": lolUser.flexTier,
          "flexRank": lolUser.flexRank,
          "flexLeaguePoints": lolUser.flexLeaguePoints,
        });
        break;
      case "pubg":
        await firestore
            .collection("user")
            .doc(_authenticationProvider.currentUser.uid)
            .collection("accounts")
            .doc(widget.snapshot.data.docs[_selectedIndex].id)
            .get()
            .then((element) {
          accountName = element.data()["name"];
        });
        print(accountName);
        break;
    }
    setState(() {
      _isPreloaded = true;
    });
  }

  Future _preloadImages() async {
    await firestore.collection("gamelist").get().then((snapshots) {
      snapshots.docs.forEach((element) {
        _images.putIfAbsent(
            element.data()["id"],
            () => Image.asset(
                "assets/images/game_icons/${element.data()["id"]}.png"));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _preloadImages().then((_) {
      _images.forEach((key, value) async {
        await precacheImage(value.image, context).then((_) {
          setState(() {});
        });
        _imageLoaded = true;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authenticationProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    _lolProfileProvider =
        Provider.of<LOLProfileProvider>(context, listen: false);
    if (!_isPreloaded) _refreshGameProfile();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("게시물 작성")),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: _imageLoaded
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("게임 선택",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      SizedBox(height: 6.0),
                      Container(
                        padding: EdgeInsets.only(bottom: 10.0),
                        height: 60.0,
                        alignment: Alignment.centerLeft,
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            return radioButton(
                                _images[widget.snapshot.data.docs[index].id],
                                index);
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(width: 4.0);
                          },
                        ),
                      ),
                      _loadUserProfile(),
                    ],
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Center(child: CircularProgressIndicator())),
          ),
        ),
      ),
    );
  }

  Widget radioButton(Image image, int index) {
    return FloatingActionButton(
      heroTag: null,
      onPressed: () => changeRadioButtonIndex(index),
      backgroundColor: _selectedIndex == index ? Colors.red : Colors.black26,
      child: Padding(padding: EdgeInsets.all(2.0), child: image),
    );
  }

  Widget _loadUserProfile() {
    switch (widget.snapshot.data.docs[_selectedIndex].id) {
      case "lol":
        LOLUser lolUser = _lolProfileProvider.lolUser;
        return LOLPostPage(lolUser: lolUser);
        break;
      default:
        return Container();
        break;
    }
  }
}
