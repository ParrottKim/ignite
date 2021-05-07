import 'package:flutter/material.dart';
import 'package:ignite/src/widgets/sign_in_page.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

class IntroPage extends StatefulWidget {
  static const String id = "/introPage";
  IntroPage({Key key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  List<Slide> slides = [];

  Function goToTab;

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "환영합니다!",
        styleTitle: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
        description: "Ignite는 모든 플레이어들을 위한\n실시간 매칭 플랫폼입니다.",
        styleDescription: TextStyle(fontSize: 20.0),
        pathImage: "assets/intro1.jpg",
      ),
    );
    slides.add(
      new Slide(
        title: "MUSEUM",
        styleTitle: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
        description:
            "Ye indulgence unreserved connection alteration appearance",
        styleDescription: TextStyle(fontSize: 20.0),
        pathImage: "assets/intro1.jpg",
      ),
    );
    slides.add(
      new Slide(
        title: "COFFEE SHOP",
        styleTitle: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
        description:
            "Much evil soon high in hope do view. Out may few northward believing attempted. Yet timed being songs marry one defer men our. Although finished blessing do of",
        styleDescription: TextStyle(fontSize: 20.0),
        pathImage: "assets/intro1.jpg",
      ),
    );
  }

  void onDonePress() {
    // Back to the first tab
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => SignInPage()));
  }

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      size: 35.0,
      color: Theme.of(context).accentColor,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Theme.of(context).accentColor,
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Theme.of(context).accentColor,
    );
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = [];
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                    child: Image.asset(
                  currentSlide.pathImage,
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.contain,
                )),
                Container(
                  child: Text(
                    currentSlide.title,
                    style: currentSlide.styleTitle,
                    textAlign: TextAlign.center,
                  ),
                  margin: EdgeInsets.only(top: 20.0),
                ),
                Container(
                  child: Text(
                    currentSlide.description,
                    style: currentSlide.styleDescription,
                    textAlign: TextAlign.center,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  margin: EdgeInsets.only(top: 20.0),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: new IntroSlider(
          // List slides
          // slides: this.slides,

          // Skip button
          renderSkipBtn: this.renderSkipBtn(),

          // Next button
          renderNextBtn: this.renderNextBtn(),

          // Done button
          renderDoneBtn: this.renderDoneBtn(),
          onDonePress: this.onDonePress,

          // Dot indicator
          colorDot: Theme.of(context).primaryColor,
          sizeDot: 13.0,
          typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,

          // Tabs
          listCustomTabs: this.renderListCustomTabs(),
          backgroundColorAllSlides: Colors.white,
          refFuncGoToTab: (refFunc) {
            this.goToTab = refFunc;
          },

          // Behavior
          scrollPhysics: BouncingScrollPhysics(),

          // Show or hide status bar
          hideStatusBar: false,

          // On tab change completed
          onTabChangeCompleted: this.onTabChangeCompleted,
        ),
      ),
    );
  }
}
