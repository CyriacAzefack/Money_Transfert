

import 'package:flutter/material.dart';

class MyGradiant extends BoxDecoration{

  static final FractionalOffset begin=FractionalOffset(0.0, 0.0);
  static final FractionalOffset endHorizontal=FractionalOffset(1.0, 0.0);
  static final FractionalOffset endVertical=FractionalOffset(0.0, 1.0);

  MyGradiant({
    @required Color startColor,
    @required Color endColor,
    bool horizontal:false,
    double radius: 0.0, radiusBL:0.0, radiusBR:0.0,
    bool bl:true, br:true,
}):super(
    gradient:LinearGradient(
      colors: [startColor, endColor],
      begin:begin,
      end: (horizontal)?endHorizontal:endVertical,
      tileMode: TileMode.clamp
    ),
    borderRadius:BorderRadius.only(topLeft: Radius.circular(radius), topRight: Radius.circular(radius), bottomLeft: Radius.circular((bl)?radius:radiusBL), bottomRight: Radius.circular((br)?radius:radiusBR))
  );
}