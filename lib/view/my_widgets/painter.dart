import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class MyPainter extends CustomPainter{

  Paint painter;
  final PageController pageController;

  MyPainter(this.pageController):super(repaint:pageController){
    painter=Paint()
        ..color=base
        ..style=PaintingStyle.fill;

  }
  @override
  void paint(Canvas canvas, Size size){
    if(pageController!=null && pageController.position!=null){
      final radius=25.0;
      final dy=30.0;
      final dxCurrent=30.0;
      final dxTarget=145.0;
      final position=pageController.position;
      final extend=(position.maxScrollExtent-position.minScrollExtent+position.viewportDimension);
      final offset=position.extentBefore/extend;
      bool toRight=dxCurrent<dxTarget;
      Offset entry=Offset(toRight?dxCurrent:dxTarget, dy);
      Offset target=Offset(toRight?dxTarget:dxCurrent, dy);
      Path path=Path();
      path.addArc(Rect.fromCircle(center: entry, radius: radius), 0.5*pi, 1+pi);
      path.addRect(Rect.fromLTRB(entry.dx, dy-radius, target.dx, dy+radius));
      path.addArc(Rect.fromCircle(center: target, radius: radius), 1.5*pi, 1*pi);
      canvas.translate(size.width*offset, 0.0);
      canvas.drawShadow(path, base, 2, true);
      canvas.drawPath(path, painter);
    }
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate)=>true;
}