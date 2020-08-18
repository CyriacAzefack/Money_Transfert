import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_transfert/view/my_widgets/constants.dart';
import 'package:money_transfert/view/my_widgets/my_gradiant.dart';
import 'package:money_transfert/view/my_widgets/painter.dart';

class Menu2Item extends StatelessWidget{
  final String item1;
  final String item2;
  final PageController pageController;

  Menu2Item({@required String this.item1, @required String this.item2, @required PageController this.pageController});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 350.0,
      height: 60.0,
      decoration: MyGradiant(startColor: pointer, endColor: base, horizontal: true, radius: 20.0),
      child: CustomPaint(
        painter: MyPainter(pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            itemButton(item1),
            itemButton(item2),
          ]
          ,
        ),
      )
    );
  }
  
  Expanded itemButton(String name){
    return Expanded(
      child:FlatButton(
          onPressed: (){
            int page=(pageController.page==0.0)?1:0;
            pageController.animateToPage(page, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
          },
          child: Text(
              name,
            style: TextStyle(
              color: white,
              fontWeight: FontWeight.bold,
              fontSize: 20.0
            ),
          )
      )
    );
  }
}