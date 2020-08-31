import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vct;
import 'dart:math' as math;

class HalfPainter extends CustomPainter {
  HalfPainter(Color paintColor) {
    this.arcPaint = Paint()
      ..color = paintColor
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;
  }

  Paint arcPaint;

  @override
  void paint(Canvas canvas, Size size) {
//    final Rect beforeRect = Rect.fromLTWH(0, (size.height / 2) - 10, 10, 10);
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.width);

    double y = size.width / 2 - math.sin(vct.radians(135)) * size.width / 2;
    var dx = y / 2;

    print(
        'yyy-->> $y |  ${size.width} |${size.height}  | ${math.sin(vct.radians(135)) * size.width / 2}');
    final Rect left = Rect.fromLTWH(0, y / 2, y, y);

//    final Rect largeRect = Rect.fromLTWH(10, 0, size.width - dx, size.height);
//    final Rect afterRect =
//        Rect.fromLTWH(size.width - 10, (size.height / 2) - 10, 10, 10);
    var x = size.width - y;

    Path path = Path();

    Paint paint = Paint()..color = Colors.amber;

    path.arcTo(rect, vct.radians(-45), vct.radians(-90), false);
    path.quadraticBezierTo(y / 2, y + dx, 0, y + dx);

    path.moveTo(size.width-y, y);
    path.quadraticBezierTo(x+y/2, y+dx, size.width, y+dx);


    Path pathFull = Path.from(path);
    Path pathInner = Path.from(path);
    path = path.transform(Matrix4.translationValues(0, 5, 0).storage);

//    pathInner = pathInner.transform(Matrix4.translationValues(0, 25, 0).storage);
//    path.addPath(pathInner, Offset.zero);
//    path.moveTo(size.width-y, y);
//    path.extendWithPath(pathInner, Offset.zero);

    pathFull.lineTo(size.width, size.width);
    pathFull.lineTo(0, size.height);
    pathFull.lineTo(0, y + dx);
//    pathFull.moveTo(y, y);
//    pathFull.close();
//    path.close();
//    Rect rect2  = path;

    paint.style = PaintingStyle.fill;

//    paint.blendMode = BlendMode.hue;
//    pathFull.getBounds()

//    arcPaint.style = PaintingStyle.fill;

    canvas.drawPath(path, arcPaint);
//    canvas.drawRect(rect, paint);
//    canvas.drawPath(pathInner, arcPaint);
//    canvas.drawPath(pathFull, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
