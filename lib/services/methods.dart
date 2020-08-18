import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_transfert/models/recipient.dart';
import 'package:money_transfert/models/transaction.dart';
import 'package:money_transfert/view/my_widgets/constants.dart';
import 'package:money_transfert/view/my_widgets/myText.dart';
import 'package:money_transfert/view/my_widgets/my_gradiant.dart';

import '../recipentSend.dart';

class Methodes{

  void snack(String text, BuildContext context){
    SnackBar snackBar=new SnackBar(
      content: MyText(text),
      duration: new Duration(seconds: 5),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  hideKeyboard(BuildContext context){
    FocusScope.of(context).requestFocus(FocusNode());
  }

  List<Recipient> getRecipients(DocumentSnapshot recipientDocs, List<Recipient> list){
    List<Recipient> myList=list;
    Recipient recipient=Recipient(me,recipientDocs);
    if(myList.every((r)=>r.documentId!=recipient.documentId)){
      myList.add(recipient);
    }else{
      Recipient toBeChanged=myList.singleWhere((r)=>r.documentId==recipient.documentId);
      myList.remove(toBeChanged);
      myList.add(recipient);
    }
    //myList.sort((a, b)=>a.name.toString().toLowerCase().compareTo(b.name.toString().toLowerCase()));
    return myList;
  }

  List<UserTransaction> getTransactions(DocumentSnapshot documentSnapshot, List<UserTransaction> list){
    List<UserTransaction> myList=list;
    UserTransaction transaction=UserTransaction(me,documentSnapshot);
    if(myList.every((t)=>t.documentId!=transaction.documentId)){
      myList.add(transaction);
    }else{
      UserTransaction toBeChanged=myList.singleWhere((r)=>r.documentId==transaction.documentId);
      myList.remove(toBeChanged);
      myList.add(transaction);
    }
    return myList;
  }

  Future<Null> showAlertBox(String title, String text, BuildContext context) async{
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return SimpleDialog(
            title: MyText(title, color: Colors.black,),
            contentPadding: EdgeInsets.all(7.0),
            children: <Widget>[
              MyText(text, color: Colors.black54,),
              RaisedButton(
                onPressed: ((){
                  Navigator.pop(context);
                }),
                child: MyText("Ok"),
                color: base,
                textColor: white,
              )
            ],
          );
        }
    );
  }

  String capitalization(String text){
    if(text==null) throw ArgumentError("string: $text");

    if(text.isEmpty) return text;

    return text
        .split(' ')
        .map((word)=>word.substring(0,1).toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

}