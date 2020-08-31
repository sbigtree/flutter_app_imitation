import 'package:flutter/material.dart';

class BorderPaint extends StatefulWidget {
  @override
  _BorderPaintState createState() => _BorderPaintState();
}

class _BorderPaintState extends State<BorderPaint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BorderPaint'),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 20),
        children: [
          Column(
            children: [
              Container(
                width: 100,
                height: 100,
                color: Colors.black12,
                child: CustomPaint(
                  painter: BorderPainter(),
                  child: Text('1111111'),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.amber,
                ),
                child: Text('1111111'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    Radius radius = Radius.circular(15);

    // 外画边框
    final RRect outer = RRect.fromRectAndCorners(
      rect,
      topLeft: radius,
      topRight: radius,
      bottomLeft: radius,
      bottomRight: radius,
    );

    final RRect inner = outer.deflate(1);

    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.indigoAccent;
    Paint paintFull = Paint()..color = Colors.amber;

    // 填背景色
    canvas.drawRRect(outer, paintFull);
//    canvas.drawRRect(inner, paintFull);


    // 画边框
    canvas.drawDRRect(outer, inner, paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
//    throw UnimplementedError();
  }
}
