import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:ignite/src/providers/authentication_provider.dart';
import 'package:ignite/src/widgets/dashboard_page.dart';
import 'package:ignite/src/widgets/sign_up_page.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  AuthenticationProvider _authenticationProvider;

  TextEditingController _emailController;
  TextEditingController _passwordController;

  FocusNode _emailFocusNode;
  FocusNode _passwordFocusNode;

  String loginStatus;
  Color loginStringColor = Colors.green;

  void signInRequest() async {
    if (_emailController.text != null && _passwordController.text != null) {
      await _authenticationProvider
          .signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      )
          .then((result) {
        if (result == null) {
          print(result);
          setState(() {
            loginStatus = "You have successfully signed in";
            loginStringColor = Colors.green;
          });
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => DashboardPage()));
        } else if (result == "이메일 주소 인증이 필요합니다") {
          setState(() {
            loginStatus = result;
            loginStringColor = Colors.green;
          });
          emailVerificationDialog();
        } else {
          setState(() {
            loginStatus = result;
            loginStringColor = Colors.red;
          });
        }
      });
    } else {
      setState(() {
        loginStatus = "Please enter email & password";
        loginStringColor = Colors.red;
      });
    }
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignUpPage(),
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authenticationProvider = Provider.of<AuthenticationProvider>(context);
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailController.text = null;
    _passwordController.text = null;
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: "PLAY",
                                style: TextStyle(
                                    fontFamily: "BarlowSemiCondensed",
                                    fontSize: 54.0)),
                            TextSpan(
                                text: ".\n",
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontFamily: "BarlowSemiCondensed",
                                    fontSize: 54.0)),
                            TextSpan(
                                text: "TOGETHER",
                                style: TextStyle(
                                    fontFamily: "BarlowSemiCondensed",
                                    fontSize: 54.0)),
                            TextSpan(
                                text: ".",
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontFamily: "BarlowSemiCondensed",
                                    fontSize: 54.0)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            border: new Border(
                                bottom:
                                    new BorderSide(color: Colors.redAccent))),
                        child: TextField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              fillColor: Colors.redAccent,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              labelText: "Email",
                              icon: Icon(
                                Icons.email,
                              ),
                              // prefix: Icon(icon),
                              border: InputBorder.none),
                          onSubmitted: (value) {
                            _emailFocusNode.unfocus();
                            FocusScope.of(context)
                                .requestFocus(_passwordFocusNode);
                          },
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            border: new Border(
                                bottom:
                                    new BorderSide(color: Colors.redAccent))),
                        child: TextField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          obscureText: true,
                          decoration: InputDecoration(
                              fillColor: Colors.redAccent,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              labelText: "Password",
                              icon: Icon(
                                Icons.lock,
                              ),
                              // prefix: Icon(icon),
                              border: InputBorder.none),
                          onSubmitted: (value) {
                            _passwordFocusNode.unfocus();
                            signInRequest();
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      loginStatus != null
                          ? Center(
                              child: Text(loginStatus,
                                  style: TextStyle(
                                      color: loginStringColor, fontSize: 14.0)))
                          : Container(),
                      SizedBox(height: 15),
                      MaterialButton(
                        elevation: 0,
                        minWidth: double.maxFinite,
                        height: 50,
                        onPressed: () {
                          setState(() {
                            _emailFocusNode.unfocus();
                            _passwordFocusNode.unfocus();
                          });
                          signInRequest();
                        },
                        color: Theme.of(context).accentColor,
                        child: Text("Sign In",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        textColor: Colors.white,
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).accentColor)),
                        child: MaterialButton(
                          elevation: 0,
                          minWidth: double.maxFinite,
                          height: 50,
                          onPressed: () {
                            Navigator.push(context, _createRoute());
                          },
                          color: Colors.white,
                          child: Text("Sign Up",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 16)),
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  emailVerificationDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AssetGiffyDialog(
        image: Image.asset("assets/images/email_verification.gif",
            fit: BoxFit.cover),
        cornerRadius: 0.0,
        buttonRadius: 0.0,
        onlyOkButton: true,
        title: Text(
          "이메일 인증",
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
        ),
        description: Text(
          "인증 메일을 보냈습니다\n이메일 확인 후, 다시 로그인 하세요",
          textAlign: TextAlign.center,
          style: TextStyle(),
        ),
        entryAnimation: EntryAnimation.DEFAULT,
        buttonOkColor: Theme.of(context).accentColor,
        onOkButtonPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
