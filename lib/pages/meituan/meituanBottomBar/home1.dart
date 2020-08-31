import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'paint/half_painter.dart';
import 'tabitem.dart';

class Home1 extends StatefulWidget {
  @override
  _Home1State createState() => _Home1State();
}

class _Home1State extends State<Home1> with TickerProviderStateMixin {
  AnimationController animaContainer;
  Animation<Color> animationColor;
  Animation<double> animationTop;
  Animation<double> animationTranslate;
  Alignment _dragAlignment = Alignment(-2.0, 1);
  Animation<Alignment> _animationAlign;
  double translateY = 30;
  double strokeWidth = 5;
  bool select = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animaContainer =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);

//    animationTop = Tween(begin: 0.0, end: 30.0).animate(animaContainer);

//    animationTop = CurvedAnimation(parent: animationTop, curve: Curves.easeInBack);
    // 设置动画曲线，开始快慢，先加速后减速
    animationTop =
        CurvedAnimation(parent: animaContainer, curve: Curves.easeOutBack);
    // Tween设置动画的区间值，animate()方法传入一个Animation，AnimationController继承Animation
    animationTop =
        new Tween(begin: 0.0, end: -translateY).animate(animationTop);

    animationColor = ColorTween(begin: Colors.transparent, end: Colors.yellow)
        .animate(
            CurvedAnimation(parent: animaContainer, curve: Curves.easeOutExpo));

    animaContainer.addListener(() {
      setState(() {
//        _dragAlignment = _animationAlign.value;
//        print('角度-->>> ${animationTop.value}');
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animaContainer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            Container(
              width: 300,
              height: 200,
              margin: EdgeInsets.only(top: 130),
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                double itemWidth = constraints.maxHeight;
                double y = itemWidth / 2 -
                    math.sin(math.pi * 135 / 180) * itemWidth / 2;
                return Stack(
                  overflow: Overflow.visible,
//                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(
                            width: strokeWidth,
                            color: Colors.black26,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        width: itemWidth,
//                    color: Colors.yellow,
                        child: Container(
                          width: itemWidth,
                          height: double.infinity,
                          child: Stack(
                            overflow: Overflow.visible,
                            alignment: AlignmentDirectional.center,
                            children: [
                              Positioned(
                                top: animationTop.value,
                                child: Container(
                                  width: itemWidth * .7,
                                  height: itemWidth * .7,
//                                  color: Colors.yellow,
                                  child: CustomPaint(
                                    painter: HalfPainter(
                                      translateY: translateY,
                                      strokeWidth: strokeWidth,
                                      animationTop: animationTop,
                                    ),
                                    child: AnimatedBuilder(
                                      animation: animaContainer,
                                      builder:
                                          (BuildContext context, Widget child) {
                                        double dy = Tween(
                                                begin: 0.0,
                                                end: translateY - 10.0)
                                            .transform(animaContainer.value);
//                                           print('dy---$dy | ${animaContainer.value}');
                                        return Transform.translate(
                                          offset: Offset(0.0, dy),
                                          child: Opacity(
                                            opacity: 1,
                                            child: Container(
                                              margin: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: animaContainer
                                                            .isCompleted ||
                                                        animaContainer
                                                            .isAnimating
                                                    ? Colors.yellow
                                                    : Colors.transparent,
                                              ),
                                              child: Icon(
                                                Icons.account_circle,
                                                size: 100,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment(0, 0.8),
                                child: FractionallySizedBox(
                                  heightFactor: 0.3,
                                  child: Container(
//                                    color: Colors.green,
                                    width: itemWidth * 0.7,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '地址',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
        Container(
          width: 200,
          height: 150,
          margin: EdgeInsets.only(top: 10),
          color: Colors.blue,
          child: Row(
            children: [
//              TabItem(
//                index: 0,
//                selected: select,
//                translateY: 20,
//              ),
              TabItem(
                selected: !select,
                index: 0,
                translateY: 20,
                iconColor: Colors.black,
                iconData: Icons.account_circle,
              ),
            ],
          ),
        ),
        FlatButton(
          onPressed: () {
//            _animationAlign = animaContainer.drive(
//              AlignmentTween(
//                begin: _dragAlignment,
//                end: Alignment.center,
//              ),
//            );
//            animaContainer.animateTo(1);
            if (animationTop.isCompleted) {
              animaContainer.reverse();
            } else {
              animaContainer.forward();
            }
          },
          child: Text('BorderPaint'),
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              select = !select;
            });
          },
          child: Text('BorderPaint'),
        ),
      ],
    );
  }
}
