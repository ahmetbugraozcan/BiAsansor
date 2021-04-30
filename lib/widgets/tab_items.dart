import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

enum TabItem {
  Home,
  Search,
  Blog,
  Profile,
}

class TabItemData {
  final IconData icon;
  final String title;

  TabItemData(this.icon, this.title);

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.Home: TabItemData(Icons.calendar_today, 'Kampanyalar'),
    TabItem.Profile: TabItemData(Icons.supervised_user_circle, 'Profil'),
    TabItem.Search: TabItemData(Icons.search, 'Ara'),
    TabItem.Blog: TabItemData(MaterialCommunityIcons.notebook, 'Blog')
  };
}
