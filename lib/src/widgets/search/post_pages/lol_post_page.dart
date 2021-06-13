import 'package:flutter/material.dart';
import 'package:ignite/models/dropdown_item.dart';

class LOLPostPage extends StatefulWidget {
  LOLPostPage({Key key}) : super(key: key);

  @override
  _LOLPostPageState createState() => _LOLPostPageState();
}

class _LOLPostPageState extends State<LOLPostPage> {
  DropdownItem selectedPosition;
  List<DropdownItem> items = <DropdownItem>[
    DropdownItem(
        "탑",
        Image.asset(
          "assets/images/game_icons/lol_lanes/top.png",
          height: 16.0,
          width: 16.0,
        )),
    DropdownItem(
        "정글",
        Image.asset(
          "assets/images/game_icons/lol_lanes/jungle.png",
          height: 16.0,
          width: 16.0,
        )),
    DropdownItem(
        "미드",
        Image.asset(
          "assets/images/game_icons/lol_lanes/mid.png",
          height: 16.0,
          width: 16.0,
        )),
    DropdownItem(
        "바텀",
        Image.asset(
          "assets/images/game_icons/lol_lanes/bottom.png",
          height: 16.0,
          width: 16.0,
        )),
    DropdownItem(
        "서포터",
        Image.asset(
          "assets/images/game_icons/lol_lanes/support.png",
          height: 16.0,
          width: 16.0,
        )),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20.0),
        Text("원하는 포지션 선택", style: TextStyle(fontWeight: FontWeight.w500)),
        DropdownButton<DropdownItem>(
          hint: Text("포지션"),
          value: selectedPosition,
          onChanged: (DropdownItem value) {
            setState(() {
              selectedPosition = value;
            });
            print(selectedPosition.name);
          },
          items: items.map((DropdownItem item) {
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
          decoration: BoxDecoration(
              border:
                  new Border(bottom: new BorderSide(color: Colors.redAccent))),
          child: TextField(
            // controller: _passwordController,
            // focusNode: _passwordFocusNode,
            decoration: InputDecoration(
                fillColor: Colors.redAccent,
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                labelText: "글 제목",
                // prefix: Icon(icon),
                border: InputBorder.none),
            onSubmitted: (value) {
              // _passwordFocusNode.unfocus();
              // signInRequest();
            },
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              border:
                  new Border(bottom: new BorderSide(color: Colors.redAccent))),
          child: TextField(
            // controller: _passwordController,
            // focusNode: _passwordFocusNode,
            maxLines: null,
            maxLength: 140,
            decoration: InputDecoration(
                fillColor: Colors.redAccent,
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                labelText: "글 내용",
                // prefix: Icon(icon),
                border: InputBorder.none),
            onSubmitted: (value) {
              // _passwordFocusNode.unfocus();
              // signInRequest();
            },
          ),
        ),
      ],
    );
  }
}
