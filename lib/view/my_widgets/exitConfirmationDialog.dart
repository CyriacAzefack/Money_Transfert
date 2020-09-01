
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_transfert/view/my_widgets/myText.dart';
import 'package:money_transfert/view/my_widgets/padding_with_child.dart';

import 'constants.dart';

// ignore: must_be_immutable
class ExitConfirmationDialog extends StatefulWidget{
  String titre;
  String text;
  ExitConfirmationDialog({
    @required String titre,
    @required String text,
  }){
    this.titre=titre;
    this.text=text;
  }

  @override
  _ExitConfirmationDialogState createState() => _ExitConfirmationDialogState();
}

class _ExitConfirmationDialogState extends State<ExitConfirmationDialog> {
  var elapsed;

  @override
  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _buildDialog(context, widget.titre, widget.text),
    );
  }

  _buildDialog(BuildContext context, String titre, String text) {
    return Container(
      height: 300,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: base,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
            ),
            child: PaddingWith(
              widget: Image.asset('assets/images/sad.png',
              width: 100,
              height: 100,
              key: ValueKey(elapsed),
            ),
              top: 12, bottom: 12, left: 12, right: 12,),
          ),
          SizedBox(height: 20.0,),
          MyText(titre, color: white, weight: FontWeight.bold, factor: 1.25,),
          SizedBox(height: 5.0,),
          PaddingWith(
            top: 0.0,
            left: 16.0,
            right: 16.0,
            widget: MyText(text, color: white, alignment: TextAlign.center,fontSize: 17.0,),
          ),
          PaddingWith(
            top: 0.0,
            left: 10,
            right: 10,
            bottom: 5.0,
            widget: RaisedButton(
              splashColor: pointer.withOpacity(0.9),
              child: MyText("Ok", color: base,),
              onPressed: ()=>Navigator.pop(context),
            ),
          )
        ],
      ),
    );
  }
}