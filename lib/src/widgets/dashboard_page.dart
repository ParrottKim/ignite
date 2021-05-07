import 'package:flutter/material.dart';
import 'package:ignite/src/providers/bottom_navigation_provider.dart';
import 'package:ignite/src/widgets/dashboard/main_page.dart';
import 'package:ignite/src/widgets/dashboard/my_page.dart';
import 'package:ignite/src/widgets/dashboard/recent_page.dart';
import 'package:ignite/src/widgets/dashboard/search_page.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  static const String id = "/dashboardPage";
  final int index;
  DashboardPage({Key key, this.index}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  BottomNavigationProvider _bottomNavigationProvider;
  PageController _pageController;
  int _currentIndex;

  Widget _bottomNavigationBarWidget() {
    return BottomNavigationBar(
      elevation: 0.0,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "메인"),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_search), label: "동료 찾기"),
        BottomNavigationBarItem(icon: Icon(Icons.access_time), label: "최근 이력"),
        BottomNavigationBarItem(icon: Icon(Icons.person_pin), label: "내 정보"),
      ],
      currentIndex: _bottomNavigationProvider.currentIndex,
      onTap: (index) {
        _bottomNavigationProvider.updatePage(index);
      },
    );
  }

  void onTabNav(int index) {
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 200), curve: Curves.ease);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bottomNavigationProvider =
        Provider.of<BottomNavigationProvider>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index ?? 0;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationProvider>(
      builder: (context, value, child) {
        return SafeArea(
          child: Scaffold(
            body: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                MainPage(),
                SearchPage(),
                RecentPage(),
                MyPage(),
              ],
              onPageChanged: (index) {},
            ),
            bottomNavigationBar: _bottomNavigationBarWidget(),
          ),
        );
      },
    );
  }
}
