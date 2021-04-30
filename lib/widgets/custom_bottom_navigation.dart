import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'tab_items.dart';

class CustomButtonNavigation extends StatelessWidget {
  final int currentIndex;
  Function onTap;
  CustomButtonNavigation({
    Key key,
    @required this.onTap,
    @required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        _navigationBuilder(TabItem.Search),
        _navigationBuilder(TabItem.Home),
        _navigationBuilder(TabItem.Blog),
        _navigationBuilder(TabItem.Profile),
      ],
    );
    // return CupertinoTabScaffold(
    //     resizeToAvoidBottomInset: false,
    //     tabBar: CupertinoTabBar(
    //       items: [
    //         _navigationBuilder(TabItem.Home),
    //         _navigationBuilder(TabItem.Search),
    //         _navigationBuilder(TabItem.Profile),
    //       ],
    //       onTap: (i) {
    //         onSelectedTab(TabItem.values[i]);
    //       },
    //     ),
    //     tabBuilder: (context, index) {
    //       final showItem = TabItem.values[index];
    //
    //       return CupertinoTabView(
    //         navigatorKey: navigatorKeys[showItem],
    //         builder: (context) {
    //           return pageBuilder[showItem];
    //         },
    //       );
    //     });
  }

  BottomNavigationBarItem _navigationBuilder(TabItem tabItem) {
    final buildTab = TabItemData.allTabs[tabItem];

    return BottomNavigationBarItem(
      activeIcon: Icon(
        buildTab.icon,
        size: 28,
        color: Colors.deepOrange,
      ),
      icon: Icon(
        buildTab.icon,
        color: Colors.grey,
        size: 24,
      ),
      label: buildTab.title,
    );
  }
}
