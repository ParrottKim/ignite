import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ignite/src/providers/authentication_provider.dart';
import 'package:ignite/src/widgets/registration/registration_page.dart';
import 'package:ignite/src/widgets/search/write_post_page.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  AuthenticationProvider _authenticationProvider;

  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  final _listItems = <Widget>[];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  bool _isLoading = false;

  Map _images = Map<String, Image>();
  bool _imageLoaded = false;

  String _boardId;

  int _selectedIndex = 0;

  void changeRadioButtonIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _loadItems() async {
    List fetchedList = [];
    switch (_boardId) {
      case "lol":
        await firestore
            .collection("board")
            .doc(_boardId)
            .collection("content")
            .get()
            .then((element) {
          if (element.docs.isEmpty) {
            fetchedList.add(Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.5,
                child: Center(child: Text("데이터가 없습니다."))));
          }
          element.docs.forEach((doc) {
            var image = Container(
                alignment: Alignment.centerLeft,
                width: 20.0,
                child: Image.asset(
                    "assets/images/game_icons/lol_lanes/${doc.data()["lane"]}.png",
                    fit: BoxFit.contain));
            fetchedList.add(
              Card(
                child: InkWell(
                  child: ListTile(
                    onTap: () {},
                    minLeadingWidth: 10,
                    leading: image,
                    title: Text(doc.data()["title"],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(doc.data()["content"]),
                  ),
                ),
              ),
            );
          });
        });
        break;
      case "pubg":
        await firestore
            .collection("board")
            .doc(_boardId)
            .collection("content")
            .get()
            .then((element) {
          if (element.docs.isEmpty) {
            fetchedList.add(Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.5,
                child: Center(child: Text("데이터가 없습니다."))));
          }
          element.docs.forEach((doc) {
            fetchedList.add(Card(
              child: InkWell(
                child: ListTile(
                  onTap: () {},
                  minLeadingWidth: 10,
                  title: Text(doc.data()["title"],
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('temperatory text'),
                ),
              ),
            ));
          });
        });
        break;
    }

    await Future.delayed(Duration(milliseconds: 200));
    var future = Future(() {});
    for (var i = 0; i < fetchedList.length; i++) {
      if (i < 8)
        future = future.then((_) {
          return Future.delayed(Duration(milliseconds: 50), () {
            _listItems.add(fetchedList[i]);
            _listKey.currentState?.insertItem(_listItems.length - 1);
          });
        });
      else {
        _listItems.add(fetchedList[i]);
        _listKey.currentState?.insertItem(_listItems.length - 1);
      }
    }
    await Future.delayed(Duration(milliseconds: 600));
  }

  void _unloadItems() {
    var future = Future(() {});
    for (var i = _listItems.length - 1; i >= 0; i--) {
      future = future.then((_) {
        final deletedItem = _listItems.removeAt(i);
        _listKey.currentState?.removeItem(i,
            (BuildContext context, Animation<double> animation) {
          return SlideTransition(
            position: CurvedAnimation(
              curve: Curves.easeOut,
              parent: animation,
            ).drive((Tween<Offset>(
              begin: Offset(1, 0),
              end: Offset(0, 0),
            ))),
            child: deletedItem,
          );
        });
      });
    }
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
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firestore
          .collection("user")
          .doc(_authenticationProvider.currentUser.uid)
          .collection("accounts")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot == null)
          return _registrationBody();
        else if (snapshot != null && _imageLoaded) {
          if (snapshot.connectionState == ConnectionState.active &&
              _boardId == null) {
            _boardId = snapshot.data.docs[_selectedIndex].id;
            _loadItems();
          }
          return _searchingBody(snapshot);
        }

        return _loadingBody();
      },
    );
  }

  Widget _registrationBody() {
    return Scaffold(
      appBar: AppBar(title: Text("동료 찾기")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("처음 오셨나요?\n\'게임 등록\' 버튼을 눌러 게임을 등록해주세요"),
            SizedBox(height: 20.0),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: MaterialButton(
                elevation: 0,
                minWidth: double.maxFinite,
                height: 50,
                onPressed: () {
                  Navigator.push(context, _createRoute(RegistrationPage()));
                },
                color: Theme.of(context).accentColor,
                child: Text("게임 등록",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchingBody(AsyncSnapshot<dynamic> snapshot) {
    return Scaffold(
      appBar: AppBar(
        title: Text("동료 찾기"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Container(
              padding: EdgeInsets.only(left: 10.0, bottom: 10.0),
              height: 60.0,
              alignment: Alignment.centerLeft,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return radioButton(snapshot, index);
                },
                separatorBuilder: (context, index) {
                  return SizedBox(width: 4.0);
                },
              )),
        ),
      ),
      body: _boardId != null
          ? AnimatedList(
              key: _listKey,
              shrinkWrap: true,
              initialItemCount: _listItems.length,
              itemBuilder: (context, index, animation) {
                return SlideTransition(
                  position: CurvedAnimation(
                    curve: Curves.easeOut,
                    parent: animation,
                  ).drive((Tween<Offset>(
                    begin: Offset(1, 0),
                    end: Offset(0, 0),
                  ))),
                  child: _listItems[index],
                );
              })
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(child: CircularProgressIndicator()),
            ),
      floatingActionButton: _boardId != null
          ? FloatingActionButton(
              heroTag: null,
              onPressed: () async {
                final result = await Navigator.push(
                    context, _createRoute(WritePostPage(snapshot: snapshot)));
                changeRadioButtonIndex(result);
                setState(() {
                  _isLoading = true;
                  _boardId = snapshot.data.docs[result].id;
                });
                _unloadItems();
                await _loadItems();
                setState(() {
                  _isLoading = false;
                });
              },
              child: Icon(Icons.add))
          : null,
    );
  }

  Widget _loadingBody() {
    return Scaffold(
      appBar: AppBar(title: Text("동료 찾기")),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(child: CircularProgressIndicator())),
    );
  }

  Widget radioButton(AsyncSnapshot<dynamic> snapshot, int index) {
    return FloatingActionButton(
      heroTag: null,
      onPressed: !_isLoading
          ? () async {
              // changeRadioButtonIndex(index);
              // setState(() {
              //   _isLoading = true;
              //   _boardId = snapshot.data.docs[index].id;
              // });
              // _unloadItems();
              // await _loadItems();
              // setState(() {
              //   _isLoading = false;
              // });
            }
          : null,
      backgroundColor: _selectedIndex == index ? Colors.red : Colors.black26,
      child: Padding(
          padding: EdgeInsets.all(2.0),
          child: _images[snapshot.data.docs[index].id]),
    );
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
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
