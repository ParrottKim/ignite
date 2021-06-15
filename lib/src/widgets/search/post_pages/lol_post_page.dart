import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ignite/models/dropdown_item.dart';
import 'package:ignite/models/lol.dart';
import 'package:ignite/src/providers/authentication_provider.dart';
import 'package:ignite/src/widgets/dashboard/search_page.dart';
import 'package:provider/provider.dart';

class LOLPostPage extends StatefulWidget {
  final LOLUser lolUser;
  LOLPostPage({Key key, this.lolUser}) : super(key: key);

  @override
  _LOLPostPageState createState() => _LOLPostPageState();
}

class _LOLPostPageState extends State<LOLPostPage> {
  final firestore = FirebaseFirestore.instance;
  AuthenticationProvider _authenticationProvider;

  TextEditingController _titleController;
  TextEditingController _contentController;

  FocusNode _titleFocusNode;
  FocusNode _contentFocusNode;

  bool _isTitleEditing = false;
  bool _isContentEditing = false;
  bool _isItemSelected = false;

  DropdownItem _selectedPosition;
  List<DropdownItem> _items = <DropdownItem>[
    DropdownItem(
        "탑",
        "top",
        Image.asset(
          "assets/images/game_icons/lol_lanes/top.png",
          height: 16.0,
          width: 16.0,
        )),
    DropdownItem(
        "정글",
        "jungle",
        Image.asset(
          "assets/images/game_icons/lol_lanes/jungle.png",
          height: 16.0,
          width: 16.0,
        )),
    DropdownItem(
        "미드",
        "mid",
        Image.asset(
          "assets/images/game_icons/lol_lanes/mid.png",
          height: 16.0,
          width: 16.0,
        )),
    DropdownItem(
        "바텀",
        "bottom",
        Image.asset(
          "assets/images/game_icons/lol_lanes/bottom.png",
          height: 16.0,
          width: 16.0,
        )),
    DropdownItem(
        "서포터",
        "support",
        Image.asset(
          "assets/images/game_icons/lol_lanes/support.png",
          height: 16.0,
          width: 16.0,
        )),
  ];

  void _uploadContent() async {
    if (_validateText(_titleController.text) == null &&
        _validateText(_contentController.text) == null &&
        _isItemSelected) {
      await firestore.collection("board").doc("lol").collection("content").add({
        "lane": _selectedPosition.position,
        "title": _titleController.text,
        "content": _contentController.text,
        "user": _authenticationProvider.currentUser.uid,
        "date": DateTime.now(),
      });
      Navigator.pop(context, 0);
    }
  }

  String _validateText(String value) {
    value = value.trim();

    if (value != null) {
      if (value.isEmpty) {
        return "내용을 입력해주세요";
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _titleController.text = null;
    _contentController.text = null;
    _titleFocusNode = FocusNode();
    _contentFocusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authenticationProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return widget.lolUser != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(height: 1.0),
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://ddragon.leagueoflegends.com/cdn/11.6.1/img/profileicon/${widget.lolUser.profileIconId}.png"),
                      child: Text("${widget.lolUser.summonerLevel}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12))),
                  title: Text(widget.lolUser.name,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: widget.lolUser.soloTier != null &&
                          widget.lolUser.soloRank != null
                      ? Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text:
                                      "${widget.lolUser.soloTier} ${widget.lolUser.soloRank}",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              TextSpan(text: " | "),
                              TextSpan(
                                  text: "${widget.lolUser.soloLeaguePoints}LP",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                        )
                      : Text("UNRANKED",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ),
              Divider(height: 1.0),
              SizedBox(height: 20.0),
              Text("주 포지션", style: TextStyle(fontWeight: FontWeight.w500)),
              DropdownButton<DropdownItem>(
                hint: Text("포지션"),
                value: _selectedPosition,
                onChanged: (DropdownItem value) {
                  setState(() {
                    _selectedPosition = value;
                    _isItemSelected = true;
                  });
                  print(_selectedPosition.name);
                },
                items: _items.map((DropdownItem item) {
                  return DropdownMenuItem<DropdownItem>(
                      value: item,
                      child: Row(
                        children: <Widget>[
                          item.image,
                          SizedBox(width: 10.0),
                          Text(item.name),
                        ],
                      ));
                }).toList(),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextField(
                  controller: _titleController,
                  focusNode: _titleFocusNode,
                  decoration: InputDecoration(
                      fillColor: Colors.redAccent,
                      enabledBorder: new UnderlineInputBorder(
                          borderSide: new BorderSide(color: Colors.redAccent)),
                      labelText: "글 제목",
                      errorText: _isTitleEditing
                          ? _validateText(_titleController.text)
                          : null),
                  onChanged: (value) {
                    setState(() {
                      _isTitleEditing = true;
                    });
                  },
                  onSubmitted: (value) {
                    _titleFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_contentFocusNode);
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextField(
                  controller: _contentController,
                  focusNode: _contentFocusNode,
                  maxLines: null,
                  maxLength: 140,
                  decoration: InputDecoration(
                    fillColor: Colors.redAccent,
                    enabledBorder: new UnderlineInputBorder(
                        borderSide: new BorderSide(color: Colors.redAccent)),
                    labelText: "글 내용",
                    errorText: _isContentEditing
                        ? _validateText(_contentController.text)
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _isContentEditing = true;
                    });
                  },
                  onSubmitted: (value) {
                    _contentFocusNode.unfocus();
                    _uploadContent();
                  },
                ),
              ),
              SizedBox(height: 20.0),
              MaterialButton(
                onPressed: (_validateText(_titleController.text) == null &&
                        _validateText(_contentController.text) == null &&
                        _isItemSelected)
                    ? () {
                        _uploadContent();
                      }
                    : null,
                color: Theme.of(context).accentColor,
                disabledColor: Colors.grey[350],
                minWidth: double.infinity,
                height: 50,
                child: Text("등록",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                textColor: Colors.white,
              ),
            ],
          )
        : Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 1.5,
            child: Center(child: CircularProgressIndicator()));
  }
}
