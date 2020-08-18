import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';

class EmptyScreen  extends StatefulWidget{
  String titre;
  String subTitre;
  PackageImage image;
  EmptyScreen({
    @required String titre,
    @required String subTitle,
    @required PackageImage image,
  }){
    this.titre=titre;
    this.subTitre=subTitle;
    this.image=image;
  }
  _EmptyScreen createState()=>new _EmptyScreen();
}

class _EmptyScreen extends State<EmptyScreen>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
          child: Container(
            height: 500,
            width:350,
            child:  EmptyListWidget(
                image : null,
                packageImage: widget.image,
                title: widget.titre,
                subTitle: widget.subTitre,
                titleTextStyle: Theme.of(context).typography.dense.display1.copyWith(color: Color(0xff9da9c7), fontSize: 25.0, fontFamily: "LobsterTwo", fontWeight: FontWeight.bold),
                subtitleTextStyle: Theme.of(context).typography.dense.body2.copyWith(color: Color(0xffabb8d6), fontSize: 15.0, fontFamily: "LobsterTwo", fontWeight: FontWeight.w500)
            ),
          )
      ),
    );
  }
}