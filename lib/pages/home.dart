import 'package:flutter/material.dart';
import 'package:imitation/route/export.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('导航'),
      ),
      body: ListView(
        children: [
          FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteName.meituanBottomBar);
              },
              child: Text('美团bottomBar')),
          FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteName.borderPaint);
              },
              child: Text('BorderPaint'))
        ],
      ),
    );
  }
}
