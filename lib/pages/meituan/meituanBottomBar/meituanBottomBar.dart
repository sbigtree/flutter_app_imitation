import 'package:flutter/material.dart';
import 'tabitem.dart';

import 'paint/half_clipper.dart';
import 'paint/half_painter.dart';
import 'dart:math' as math;

const double CIRCLE_SIZE = 60;
const double ARC_HEIGHT = 70;
const double ARC_WIDTH = 90;
const double CIRCLE_OUTLINE = 10;
const double SHADOW_ALLOWANCE = 20;
const double BAR_HEIGHT = 60;

typedef IndexChanged<T> = void Function(T value);

class MeituanBottomBar extends StatefulWidget {
  MeituanBottomBar({
    @required this.tabs,
    @required this.tabChange,
    this.key,
    this.initialSelection = 0,
    this.circleColor,
    this.activeIconColor,
    this.inactiveIconColor,
    this.textColor,
    this.barBackgroundColor,
  })  : assert(tabs != null),
        assert(tabs.length > 1 && tabs.length < 5);

  final Color circleColor;
  final Color activeIconColor;
  final Color inactiveIconColor;
  final Color textColor;
  final Color barBackgroundColor;
  final List<TabData> tabs;
  final int initialSelection;
  final IndexChanged<int> tabChange;
  final Key key;

  @override
  _MeituanBottomBarState createState() => _MeituanBottomBarState();
}

class _MeituanBottomBarState extends State<MeituanBottomBar> {
  IconData nextIcon = Icons.search;
  IconData activeIcon = Icons.search;

  int currentSelected = 0;
  double _circleAlignX = 0;
  double _circleIconAlpha = 1;

  Color circleColor;
  Color activeIconColor;
  Color inactiveIconColor;
  Color barBackgroundColor;
  Color textColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    activeIcon = widget.tabs[currentSelected].iconData;

    circleColor = (widget.circleColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.white
            : Theme.of(context).primaryColor
        : widget.circleColor;

    activeIconColor = (widget.activeIconColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.black54
            : Colors.white
        : widget.activeIconColor;

    barBackgroundColor = (widget.barBackgroundColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Color(0xFF212121)
            : Colors.white
        : widget.barBackgroundColor;
    textColor = (widget.textColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.white
            : Colors.black54
        : widget.textColor;
    inactiveIconColor = (widget.inactiveIconColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.white
            : Theme.of(context).primaryColor
        : widget.inactiveIconColor;
  }

  _setSelected(UniqueKey key) {
    int selected = widget.tabs.indexWhere((tabData) => tabData.key == key);
    print('currentSelected； $currentSelected');
    if (mounted) {
      setState(() {
        currentSelected = selected;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
//    return Container(child: Text('sss'),);
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      double itemWidth = constraints.maxWidth / widget.tabs.length;
      double y =
          (itemWidth / 2 - math.sin(math.pi * 135 / 180) * itemWidth / 2);
      return Stack(
        overflow: Overflow.visible,
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            height: BAR_HEIGHT,
            decoration: BoxDecoration(
              color: barBackgroundColor,
//              border: Border(top: BorderSide(width: 1, color: Colors.grey)),
//            boxShadow: [
//              BoxShadow(
//                color: Colors.black12,
//                offset: Offset(0, -1),
//                blurRadius: 8,
//              )
//            ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: widget.tabs
                  .map((t) => TabItem(
                      uniqueKey: t.key,
                      translateY: 10,
                      selected: t.key == widget.tabs[currentSelected].key,
                      iconData: t.iconData,
                      title: t.title,
                      strokeWidth: 1,
                      iconColor: activeIconColor,
                      textColor: textColor,
                      tapCallback: (uniqueKey) {
                        int selected = widget.tabs
                            .indexWhere((tabData) => tabData.key == uniqueKey);

                        print('index2-->> $selected');
//                        widget.tabChange(selected);
                        _setSelected(uniqueKey);

                      }))
                  .toList(),
            ),
          ),
        ],
      );
    });
  }
}

class TabData {
  TabData({@required this.iconData, @required this.title, this.onclick});

  IconData iconData;
  String title;
  Function onclick;
  final UniqueKey key = UniqueKey();
}
