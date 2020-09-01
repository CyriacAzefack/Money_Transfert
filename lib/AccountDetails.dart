import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_transfert/Recipients.dart';
import 'package:money_transfert/services/authentification.dart';
import 'package:money_transfert/view/my_widgets/myText.dart';
import 'package:url_launcher/url_launcher.dart';



import 'TransactionsHistory.dart';


class AccountDetails extends StatefulWidget{
  _AccountDetails createState()=>new _AccountDetails();
}

class _AccountDetails extends State<AccountDetails>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 1,
          itemBuilder: ((context, i){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ListTile(
                    title: MyText("Mes informations", alignment: TextAlign.left, weight: FontWeight.w500,),
                    leading: Icon(Icons.person,),
                  ),
                  Divider(),
                  ListTile(
                    title: MyText("Mes bénéficiaires", alignment: TextAlign.left, weight: FontWeight.w500,),
                    leading: Icon(Icons.group),
                    onTap: ((){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                        return new Recipients();
                      }));
                    }),
                  ),
                  Divider(),
                  ListTile(
                    title: MyText("Suivre un transfert", alignment: TextAlign.left, weight: FontWeight.w500,),
                    leading: Icon(Icons.location_searching),
                    onTap: ((){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                        return new FollowTransactions();
                      }));
                    }),
                  ),
                  Divider(),
                  ListTile(
                    title: MyText("Tutoriel d'utilisation", alignment: TextAlign.left, weight: FontWeight.w500,),
                    leading: Icon(Icons.live_help),
                  ),
                  Divider(),
                  ListTile(
                    title: MyText("Paramètres", alignment: TextAlign.left, weight: FontWeight.w500,),
                    leading: Icon(Icons.settings),
                  ),
                  Divider(),
                  ListTile(
                    title: MyText("A propos", alignment: TextAlign.left, weight: FontWeight.w500,),
                    leading: Icon(Icons.info),
                    onTap: ((){
//                      launchWhatsApp(message: "Test Currency Lightning");
                    }),
                  ),
                  Divider(),
                  ListTile(
                    title: MyText("Se déconnecter", alignment: TextAlign.left, weight: FontWeight.w500,),
                    leading: Icon(Icons.exit_to_app),
                    onTap: (){
                      logOutAlertDialog(context);
                    },
                  ),
                ],
              ),
            );
          })
      ),
    );
  }
}

logOutAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Annuler"),
    onPressed:  () {
      Navigator.of(context).pop(); // dismiss dialog
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Continuer"),
    onPressed:  () {
      Navigator.of(context).pop();
      AuthService().logOut();
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Déconnexion"),
    content: Text("Etes vous sûr de vouloir vous déconnecter maintenant?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}


