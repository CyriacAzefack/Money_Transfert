import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_transfert/recipents.dart';
import 'package:money_transfert/services/authentification.dart';
import 'package:money_transfert/view/my_widgets/myText.dart';

class Account extends StatefulWidget{
  _Account createState()=>new _Account();
}

class _Account extends State<Account>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                        return new Recipients();
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
                  ),
                  Divider(),
                  ListTile(
                    title: MyText("Se déconnecter", alignment: TextAlign.left, weight: FontWeight.w500,),
                    leading: Icon(Icons.exit_to_app),
                    onTap: (){
                      AuthService().logOut();
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