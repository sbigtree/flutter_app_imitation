import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'routeConfig.dart';

Route Function(RouteSettings settings) onGenerateRoute =
    (RouteSettings settings) {
  RouteResult routeResult = getRouteResult(settings.name, settings.arguments);
  var page = routeResult.widget ?? NoRoute();

  switch (routeResult.routeAnimationType) {
    case RouteAnimationType.none:
      return PageRouteBuilder(
        transitionDuration: Duration(seconds: 0), // 动画时长
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return child;
        },
      );
    case RouteAnimationType.cupertino:
      return CupertinoPageRoute(builder: (context) => page);
    default:
      return MaterialPageRoute(builder: (context) => page);
  }
};

class NoRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("can't find route"),
      ),
      body: Center(
        child: Container(
          child: Text("can't find route"),
        ),
      ),
    );
  }
}
