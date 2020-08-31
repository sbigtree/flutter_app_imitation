import 'package:flutter/material.dart';
import 'package:imitation/pages/meituan/borderPaint.dart';
import 'package:imitation/pages/meituan/meituanBootomBarPage.dart';

/// 路由动画类型
enum RouteAnimationType { material, cupertino, transparent, none }

class RouteName {
  static const String meituanBottomBar = '/meituanBottomBar';
  static const String borderPaint = '/borderPaint';
}

RouteResult getRouteResult(String name, [Map<String, dynamic> arguments]) {
  switch (name) {
    case RouteName.meituanBottomBar:
      // 首页
      return RouteResult(
        widget: MeituanBottomBarPage(),
      );
    case RouteName.borderPaint:
      // 首页
      return RouteResult(
        widget: BorderPaint(),
      );

    default:
      return RouteResult(widget: Container());
  }
}

class RouteResult {
  final Widget widget;
  final RouteAnimationType routeAnimationType;

  /// 是否不透明
  final bool opaque;

  RouteResult({
    @required this.widget,
    this.routeAnimationType = RouteAnimationType.material,
    this.opaque = true,
  });
}
