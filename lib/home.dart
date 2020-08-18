import 'dart:async';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_transfert/account_page.dart';
import 'package:money_transfert/controller/login.dart';
import 'package:money_transfert/main.dart';
import 'package:money_transfert/recent_recipient.dart';
import 'package:money_transfert/recipents.dart';
import 'package:money_transfert/transactions.dart';
import 'package:money_transfert/services/authentification.dart';
import 'package:money_transfert/services/database.dart';
import 'package:money_transfert/services/methods.dart';
import 'package:money_transfert/view/my_widgets/constants.dart';
import 'package:money_transfert/view/my_widgets/padding_with_child.dart';
import 'package:share/share.dart';
import 'add_recipient.dart';
import 'models/recipient.dart';
import 'models/user.dart';

class Home extends StatefulWidget{
  String uid;
  Home(this.uid);

  @override
  _Home createState()=>new _Home();
}

class _Home extends State<Home>{

  StreamSubscription streamListener;
  List<Recipient> recipientSheet=[];
  double width=0.0;
  int pageIndex=1;
  final pages=[
    TransactionPages(),
    RecentRecipient(),
    Account(),
  ];

  final titres=[
    "Historique de transactions",
    "Envoyer de l'argent",
    "Mon compte",
  ];

  final GlobalKey<ScaffoldState> scaffoldKey=new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    streamListener=DatabaseService().userCollection.document(widget.uid).snapshots().listen((document){
      setState(() {
        me=User(document);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    streamListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return (me==null)? MyHomePage() : Scaffold(
      key: scaffoldKey,
        appBar: new AppBar(
          title: new Text(titres[pageIndex]),
          backgroundColor: base,
          elevation: 5.0,
          actions: <Widget>[
            SizedBox(width: 30.0,),
            PaddingWith(
              widget: InkWell(
                child: (pageIndex==1)? Icon(Icons.person_add, color: white, size: 28.0, ):Container(),
                onTap: ((){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                    return new AddRecipient();
                  }));
                }),
              ),
              top: 0.0,
              right: 7.0,
            )
          ],
        ),
        body: pages[pageIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        buttonBackgroundColor: base,
        height: 50.0,
        color: base,
        index: pageIndex,
        onTap: ((index){
          setState(() {
            pageIndex=index;
          });
        }),
        animationDuration: Duration(
          milliseconds: 500,
        ),
        animationCurve: Curves.easeInOutCirc,
        items: <Widget>[
          CircleAvatar(
            radius: 15.0,
            backgroundColor:pageIndex==0? Colors.white: Colors.transparent,
            child: Icon(Icons.history, color: pageIndex==0? base:Colors.white,),
          ),
          CircleAvatar(
            radius: 17.0,
            backgroundColor:pageIndex==1? Colors.white: Colors.transparent,
            child: Icon(Icons.send, color: pageIndex==1? base:Colors.white,),
          ),
          CircleAvatar(
            radius: 15.0,
            backgroundColor:pageIndex==2? Colors.white: Colors.transparent,
            child: Icon(Icons.person, color: pageIndex==2? base:Colors.white,),
          ),
        ],
      ),
    );
  }

  shareF(BuildContext context){
    final RenderBox box =context.findRenderObject();

    Share.share("Cliquez sur le lien suivant pour partager cette application: https:www.google.com",
        sharePositionOrigin: box.localToGlobal(Offset.zero)& box.size);
  }



}