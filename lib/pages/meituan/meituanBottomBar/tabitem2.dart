import 'package:flutter/material.dart';

import 'paint/half_painter.dart';
import 'paint/xx.dart';

class TabItem extends ImplicitlyAnimatedWidget {
  TabItem({
    Key key,
    @required this.index,
    this.select = false,
    this.translateY = 30,
    this.strokeWidth = 5,
    Curve curve = Curves.easeOutBack,
    VoidCallback onEnd,
    Duration duration = const Duration(milliseconds: 400),
//    @required this.container,
  }) : super(key: key, curve: curve, duration: duration, onEnd: onEnd);

//  final Animation<double> animationTop;
//  final AnimationController container;
  final double translateY;
  final double strokeWidth;
  final index;
  final bool select;

  @override
  _TabItemState createState() => _TabItemState();
}

class _TabItemState extends ImplicitlyAnimatedWidgetState<TabItem> {
  Tween<double> _translateYTween;
  double translateY;
  Animation<double> _translateAnimation;

  @override
  void initState() {
    // TODO: implement initState
    _setTranslateY();

//    print('translateY0-->> ${translateY}');
    super.initState();
  }

  _setTranslateY() {
    if (widget.select) {
      translateY = 30;
    } else {
      translateY = 0;

    }
  }

//  @override
  void didUpdateWidget(TabItem oldWidget) {
    print('didUpdate-->> ${widget.select}');
    _setTranslateY();

    print('didUpdate-translateY->> ${translateY}');

    super.didUpdateWidget(oldWidget);


  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
//    print('translateY-->> ${translateY}');
    // widget.translateY 传给 value
    _translateYTween = visitor(_translateYTween, translateY,
            (dynamic value) => Tween<double>(begin: value as double))
        as Tween<double>;
//    _translateYTween = Tween<double>(begin: 0.0,end: 30.0);
    print('_translateY1: $_translateYTween');
  }

  @override
  void didUpdateTweens() {
    print('_translateAnimation: $_translateAnimation');
    print('animation: $animation');
    print('_translateY: $_translateYTween');

    _translateAnimation = animation.drive(_translateYTween);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        overflow: Overflow.visible,
//                  alignment: AlignmentDirectional.topCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  width: widget.strokeWidth,
                  color: Colors.black26,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
//            width: itemWidth,
//                    color: Colors.yellow,
              child: Container(
//              width: itemWidth,
                height: double.infinity,
                child: Stack(
                  overflow: Overflow.visible,
                  alignment: AlignmentDirectional.center,
                  children: [
                    Positioned(
//                      top: -_translateAnimation.value,
                    top: 0,
                      child:
//                    FractionallySizedBox(
//                      heightFactor: 0.7,
//                      child:
                          Container(
//                      width: itemWidth * .7,
//                      height: itemWidth * .7,
//                        color: Colors.yellow,
                        child: AnimatedBuilder(
                          animation: controller,
                          builder: (BuildContext context, Widget child) {
                            double dy =
                                Tween(begin: 0.0, end: widget.translateY - 10.0)
                                    .transform(controller.value);
//                                           print('dy---$dy | ${animaContainer.value}');

                            return Transform.translate(
//                                offset: Offset(0.0, dy),
                              offset: Offset(0.0, -_translateAnimation.value),
                              child: CustomPaint(
                                painter: HalfPainter(
                                  translateY: widget.translateY,
                                  strokeWidth: widget.strokeWidth,
                                  animationTop: _translateAnimation,
                                ),
                                child: Transform.translate(
                                offset: Offset(0.0, 10),
//                                  offset:
//                                      Offset(0.0, 0),
                                  child: Opacity(
                                    opacity: 1,
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: widget.select ||controller.isAnimating
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
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
//                  ),
                    Align(
                      alignment: Alignment(0, 0.8),
                      child: FractionallySizedBox(
                        heightFactor: 0.3,
                        child: Container(
//                                    color: Colors.green,
//                        width: itemWidth * 0.7,
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
      ),
    );
  }
}
