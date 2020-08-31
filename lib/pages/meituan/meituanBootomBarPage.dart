import 'package:flutter/material.dart';

import 'meituanBottomBar/home1.dart';
import 'meituanBottomBar/meituanBottomBar.dart';


class MeituanBottomBarPage extends StatefulWidget {


  @override
  _MeituanBottomBarState createState() => _MeituanBottomBarState();
}

class _MeituanBottomBarState extends State<MeituanBottomBarPage> {
  int _index = 0;
  List<Widget> tabBodyList = [
    Home1(),
    Container(
      child: Text('2'),
    ),
    Container(
      child: Text('3'),
    ),
    Container(
      child: Text('4'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('bottomBar'),
      ),
      body: IndexedStack(
        index: _index,
        children: tabBodyList,
      ),
      bottomNavigationBar: MeituanBottomBar(
        activeIconColor: Colors.black,
        tabChange: (index) {
          print('index-->> $index');
        },
        tabs: [
          TabData(iconData: Icons.home, title: "Home", onclick: (index) {}),
          TabData(iconData: Icons.search, title: "Search", onclick: (index) {}),
          TabData(
              iconData: Icons.shopping_cart,
              title: "Basket",
              onclick: (index) {}),
          TabData(
              iconData: Icons.account_circle,
              title: "Basket",
              onclick: (index) {})
        ],
        initialSelection: 0,
      ),
    );
  }
}
