import 'package:flutter/material.dart';
import 'package:money_transfert/view/my_widgets/constants.dart';

class MyText extends Text{
  MyText(data,{
    TextAlign alignment:TextAlign.center,
    double fontSize:20.0,
    FontWeight weight:FontWeight.normal,
    FontStyle style:FontStyle.normal,
    TextOverflow overflow:TextOverflow.ellipsis,
    int maxLine:50,
    double factor:1.0,
    Color color:black
  }):super(
    data,
    overflow:overflow,
    maxLines:maxLine,
    textAlign:alignment,
    textScaleFactor:factor,
    style:TextStyle(
      fontSize: fontSize,
      fontStyle: style,
      fontFamily: "LobsterTwo",
      color: color,
      fontWeight: weight
    )
  );
}