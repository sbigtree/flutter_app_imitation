import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'paint/half_painter.dart';

typedef TapCallback = void Function(UniqueKey uniqueKey);

class TabItem extends StatefulWidget {
  TabItem({
    Key key,
    this.selected = false,
    this.translateY = 20,
    this.strokeWidth = 1,
    this.outCurve = Curves.easeOutExpo,
    this.inCurve = Curves.easeOutBack,
    @required this.index,
    this.onEnd,
    this.title,
    this.iconData,
    this.textColor,
    this.unSelectedIconColor = Colors.grey,
    this.textStyle,
    this.iconColor,
    this.strokeColor,
    this.uniqueKey,
    @required this.tapCallback,
    this.duration = const Duration(milliseconds: 300),
  });

  final UniqueKey uniqueKey;
  final String title;
  final IconData iconData;
  final Color textColor;
  final Color iconColor;
  final Color strokeColor;
  final Color unSelectedIconColor;
  final TextStyle textStyle;
  final double translateY;
  final double strokeWidth;
  final bool selected;
  final int index;
  final Curve outCurve;
  final Curve inCurve;
  final Duration duration;
  final VoidCallback onEnd;
  final TapCallback tapCallback;


  @override
  _TabItemState createState() => _TabItemState();
}

class _TabItemState extends State<TabItem> with SingleTickerProviderStateMixin {
  Tween<double> _translateYTween;
  double translateY;
  Animation<double> _translateAnimation;

  /// The animation controller driving this widget's implicit animations.
  @protected
  AnimationController get controller => _controller;
  AnimationController _controller;

  /// The animation driving this widget's implicit animations.
  Animation<double> get animation => _animation;
  Animation<double> _animation;

  Curve _curve;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setTranslateY();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _controller.addStatusListener((AnimationStatus status) {
      switch (status) {
        case AnimationStatus.completed:
          if (widget.onEnd != null) widget.onEnd();
          break;
        case AnimationStatus.dismissed:
        case AnimationStatus.forward:
        case AnimationStatus.reverse:
      }
    });

    _updateCurve();
    _constructTweens();
    if (_translateYTween.end == null) {
//      _translateYTween.end = widget.selected? 0:widget.translateY;
    }
    didUpdateTweens();

//    _controller
//      ..value = 0.0
//      ..forward();
//    print('translateY0-->> ${translateY}');
  }

//  bool get  isConstructTweens => _constructTweens();

  _setTranslateY() {
    if (widget.selected) {
      translateY = widget.translateY;
      _curve = widget.inCurve;
    } else {
      translateY = 0;
      _curve = widget.outCurve;
    }
  }

  Tween get colorTween {
    if (_translateYTween.end == null) {
      /// 解决首次tween初始化不对的问题
      /// 首次是 true 颜色应该是 黄->白
      /// 点击后 false 颜色应该是 黄->白
      /// 再击后 true 颜色应该是 白->黄
      /// ...
      /// 再击后 true 颜色应该是 白->黄
      if (widget.selected) {
        return Tween(begin: 1.0, end: 0.0);
        return ColorTween(begin: Colors.yellow, end: Colors.white);
      } else {
        return Tween(begin: .0, end: 1.0);
        return ColorTween(begin: Colors.white, end: Colors.yellow);
      }
    } else {
      if (!widget.selected) {
        return Tween(begin: 1.0, end: 0.0);
        return ColorTween(begin: Colors.yellow, end: Colors.white);
      } else {
        return Tween(begin: .0, end: 1.0);

        return ColorTween(begin: Colors.white, end: Colors.yellow);
      }
    }
  }

  @override
  void didUpdateWidget(TabItem oldWidget) {
    print('didUpdate-->> ${widget.selected}');
    _setTranslateY();
    print('didUpdate-translateY->> ${translateY}');
//    print('didUpdate-_curve->> ${_curve != oldWidget.curve}');

    super.didUpdateWidget(oldWidget);
//    if (_curve != oldWidget.curve) _updateCurve();
    _updateCurve();
    _controller.duration = widget.duration;
    if (_constructTweens()) {
      print('targetValue: $_translateYTween');

      forEachTween((Tween<dynamic> tween, dynamic targetValue,
          TweenConstructor<dynamic> constructor) {
        _updateTween(tween, targetValue);
        return tween;
      });
      _controller
        ..value = 0.0
        ..forward();

      didUpdateTweens();
    }
  }

  void _updateCurve() {
    if (_curve != null)
      _animation = CurvedAnimation(parent: _controller, curve: _curve);
    else
      _animation = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateTween(Tween<dynamic> tween, dynamic targetValue) {
    if (tween == null) return;

    tween
      ..begin = tween.evaluate(_animation)
      ..end = targetValue;
  }

  bool _shouldAnimateTween(Tween<dynamic> tween, dynamic targetValue) {
    print('_shouldAnimateTween: $tween');
    print(
        '_constructTweens: ${targetValue != (tween.end ?? tween.begin)} | ${(tween.end ?? tween.begin)} | targetValue: $targetValue');
    return targetValue != (tween.end ?? tween.begin);
  }

  // 初始化Tween, 在didUpdateWidget的时候
  bool _constructTweens() {
    bool shouldStartAnimation = false;
    forEachTween((Tween<dynamic> tween, dynamic targetValue,
        TweenConstructor<dynamic> constructor) {
      if (targetValue != null) {
        tween ??= constructor(targetValue);
        if (_shouldAnimateTween(tween, targetValue))
          shouldStartAnimation = true;
      } else {
        tween = null;
      }
      return tween;
    });
    print('shouldStartAnimation: $shouldStartAnimation');
    return shouldStartAnimation;
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

  // 更新映射
  @override
  void didUpdateTweens() {
    print('_translateAnimation: $_translateAnimation');
    print('animation: $animation');

    _translateAnimation = animation.drive(_translateYTween);
    print('_translateY: $_translateYTween');
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          widget.tapCallback(widget.uniqueKey);
        },
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double itemWidth = constraints.maxHeight;
            double y =
                itemWidth / 2 - math.sin(math.pi * 135 / 180) * itemWidth / 2;
            return Stack(
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
                    child: Container(
                      height: double.infinity,
                      child: Stack(
                        overflow: Overflow.visible,
                        alignment: AlignmentDirectional.center,
                        children: [
                          Positioned(
                            top: 0,
                            child: Container(
                              width: itemWidth * .8,
                              height: itemWidth * .8,
//                          color: Colors.yellow,
                              child: AnimatedBuilder(
                                animation: controller,
                                builder: (BuildContext context, Widget child) {
                                  double opacity =
                                      colorTween.evaluate(controller);
                                  return Transform.translate(
                                    offset:
                                        Offset(0.0, -_translateAnimation.value),
                                    child: CustomPaint(
                                      painter: HalfPainter(
                                        tickerType: TickerType.reset,
                                        translateY: widget.translateY,
                                        strokeWidth: widget.strokeWidth,
                                        animationTop: _translateAnimation,
                                      ),
                                      child: Transform.translate(
                                        offset: Offset(
                                            0.0, _translateAnimation.value / 3),
                                        child: Stack(
                                          children: [
                                            Positioned.fill(
                                              child: Opacity(
                                                opacity: opacity,
                                                child: ClipRRect(
//                                                  borderRadius: BorderRadius.circular(130),
                                                  child: Container(
                                                    margin: EdgeInsets.all(
                                                        widget.translateY / 3),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
//                                                      color: Colors.yellow,
                                                      gradient: LinearGradient(
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        colors: [
                                                          Color(0xffF2CB28),
                                                          Colors.yellow
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              child: Icon(
                                                widget.iconData,
                                                color: widget.selected
                                                    ? widget.iconColor
                                                    : widget
                                                        .unSelectedIconColor,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment(0, 0.9),
                            child: FractionallySizedBox(
                              heightFactor: 0.3,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  '${widget.title}',
                                  style: widget.textStyle,
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
          },
        ),
      ),
    );
  }
}
