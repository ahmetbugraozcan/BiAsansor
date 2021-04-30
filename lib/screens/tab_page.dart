import 'package:flutter/material.dart';
import 'package:flutter_biasansor/notification_handler.dart';
import 'package:flutter_biasansor/screens/tab_pages/blog_page.dart';
import 'package:flutter_biasansor/widgets/custom_bottom_navigation.dart';
import 'tab_pages/campaigns_page.dart';
import 'tab_pages/profile_page.dart';
import 'tab_pages/search_page.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _selectedIndex = 0;
  static final List<Widget> _pages = <Widget>[
    SearchPage(),
    HomePage(),
    BlogPage(),
    ProfilePage(),
  ];
  @override
  void initState() {
    super.initState();
    NotificationHandler().initializeFCMNotifications(context);
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   var _viewModel = Provider.of<ViewModel>(context,listen: false);
    //
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomButtonNavigation(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: _pages.elementAt(_selectedIndex),
    );
  }
}
