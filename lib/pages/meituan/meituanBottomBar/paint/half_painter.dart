import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vct;
import 'dart:math' as math;

enum TickerType { reset, reverse }

class HalfPainter extends CustomPainter {
  HalfPainter({
//    this.animation,
    this.animationTop,
    this.translateY,
    this.strokeWidth = 1,
    this.backgroundColor = Colors.white,
    this.strokeColor = Colors.black26,
    this.tickerType =TickerType.reverse,
  }) {
    this.arcPaint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..color = strokeColor;
  }

//  final Animation<double> animation;
  final Animation<double> animationTop;
  double translateY;
  Paint arcPaint;
  Color backgroundColor;
  Color strokeColor;
  double strokeWidth;
  TickerType tickerType;

  @override
  void paint(Canvas canvas, Size size) {
//    final Rect beforeRect = Rect.fromLTWH(0, (size.height / 2) - 10, 10, 10);
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.width);

//    double deg = animation.value;

    double top = animationTop.value.abs();
    if (tickerType == TickerType.reset && animationTop.value < 0) {
      return;
    }

    double width = size.width;
    double r = size.width / 2;
//    print('animationTop: ${animationTop.value} | $width | $top');

    double dy = top / 2;
    // 当前相交的两点与圆心的的连线，连线与y轴的角度， 两相交半径的夹角要x2
    double sdeg = math.acos((r - translateY) / r) * 180 / math.pi;

    // 当前映射的弧度，展开
    double cr = math.acos((r - top) / r);
    // 与圆相交的直接与圆心的连线 和 y轴的夹角
    double crDeg = math.acos((r - top + dy) / r) * 180 / math.pi;
//    print('当前相交的两点与圆心的角度： $crDeg');
    // 求得展开映射弧度
    double radian = Tween(begin: 0.0, end: math.acos((r - translateY) / r) * 2)
        .transform(top / translateY);

    double cDeg = Tween(begin: 0.0, end: sdeg * 2).transform(top / translateY);

//    print('上升完成后的弧度 sdeg: ${sdeg * 2} | 当前映射的角度: $crDeg |radian：$radian ');

    // 弧线左边的结束点
    var lx = r - math.sin(vct.radians(crDeg)) * r;
    var ly = r - math.cos(vct.radians(crDeg)) * r;
    // 弧线右边边的结束点
    var rx = r + math.sin(vct.radians(crDeg)) * r;
    var ry = r - math.cos(vct.radians(crDeg)) * r;

//    print('deg-->> ${animation.value}');
//    已知y,r, 求角度θ, cosα=y/r, θ=90-α, 从θ角度开始画，画2θ的角度的弧度

//    final Rect largeRect = Rect.fromLTWH(10, 0, size.width - dx, size.height);
//    final Rect afterRect =
//        Rect.fromLTWH(size.width - 10, (size.height / 2) - 10, 10, 10);
//    var x = size.width - y;

    Path path = Path();
    Paint paint = Paint()..color = backgroundColor;
    path.arcTo(rect, vct.radians(-90 + crDeg), vct.radians(-crDeg * 2), false);

    path.quadraticBezierTo(lx / 2, ly + (top - ly), 0, top);
//
    path.moveTo(rx, ry);
//    print('lx: ${lx} | rx ${width - rx} | ly $ly');
    path.quadraticBezierTo(rx + (width - rx) / 2, ly + (top - ly), width, top);

    Path pathFull = Path.from(path);
    Path pathInner = Path.from(path);
    path = path.transform(
        Matrix4.translationValues(0, arcPaint.strokeWidth / 2, 0).storage);

//    pathInner = pathInner.transform(Matrix4.translationValues(0, 25, 0).storage);
//    path.addPath(pathInner, Offset.zero);
//    path.moveTo(size.width-y, y);
//    path.extendWithPath(pathInner, Offset.zero);

    pathFull.lineTo(size.width, size.width);
    pathFull.lineTo(0, size.height);
    pathFull.lineTo(0, top);
//    path.moveTo(rx, ry);

//    pathFull.moveTo(y, y);
    pathFull.close();
//    path.close();
//    Rect rect2  = path;

    paint.style = PaintingStyle.fill;

//    paint.blendMode = BlendMode.hue;
//    pathFull.getBounds()

//    arcPaint.style = PaintingStyle.fill;

//    canvas.drawRect(rect, paint);
//    canvas.drawPath(pathInner, arcPaint);
    canvas.drawPath(pathFull, paint);
    canvas.drawPath(path, arcPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
