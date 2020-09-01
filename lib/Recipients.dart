import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:money_transfert/models/recipient.dart';
import 'package:money_transfert/recipentSend.dart';
import 'package:money_transfert/services/database.dart';
import 'package:money_transfert/services/methods.dart';
import 'package:money_transfert/view/my_widgets/constants.dart';
import 'package:money_transfert/view/my_widgets/loading_scafold.dart';
import 'package:money_transfert/view/my_widgets/myText.dart';
import 'package:money_transfert/view/my_widgets/my_gradiant.dart';
import 'package:money_transfert/view/my_widgets/padding_with_child.dart';

import 'CreateRecipient.dart';
import 'EmptyScreen.dart';

class Recipients extends StatefulWidget{
  @override
  _Recipients createState()=> new _Recipients();
}

class _Recipients extends State<Recipients>{

  GlobalKey<FormState> ckey=new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey=new GlobalKey<ScaffoldState>();
  String textSnack;
  StreamSubscription sub;
  List<Recipient> _recipientsList=[];

  @override
  void initState() {
    super.initState();
    // ignore: unnecessary_statements
    (this.mounted) ? setupSub()  : null;
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: MyText("Mes bénéficiaires", color: white,),
          actions: <Widget>[
            SizedBox(width: 30.0,),
            PaddingWith(
              widget: InkWell(
                child:  Icon(Icons.person_add, color: white, size: 28.0, ),
                onTap: ((){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                    return new CreateRecipient();
                  }));
                }),
              ),
              top: 0.0,
              right: 7.0,
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: DatabaseService().recipientFrom(user.uid),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.waiting:
                return LoadingScaffold();
                break;
              case ConnectionState.active:
                if(snapshot.data.documents.length>0){
                  return Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                            itemCount: _recipientsList.length,
                            itemBuilder: ((context, i){
                              Recipient recipient=_recipientsList[i];
                              return Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
                                child: InkWell(
                                    onTap: ((){
                                      globalRecipient=recipient;
                                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                                        return new RecipientSend();
                                      }));
                                    }),
                                    child: Container(
                                      padding: EdgeInsets.all(1.0),
                                      width: MediaQuery.of(context).size.width,
                                      height: 70,
                                      child: ListTile(
                                        leading: new CircleAvatar(
                                          radius: 20.0,
                                          child: ClipOval(
                                            child: SizedBox(
                                              width: 40.0,
                                              height: 40.0,
                                              child: FittedBox(
                                                fit: BoxFit.fill,
                                                alignment: Alignment.center,
                                                child: CountryPickerUtils.getDefaultFlagImage(CountryPickerUtils.getCountryByName(recipient.country)),
                                              )
                                            ),
                                          ),
                                        ),
                                        title: MyText(
                                          "${Methodes().capitalization(recipient.name + " " + recipient.surname)}",
                                          weight: FontWeight.w500,
                                          alignment: TextAlign.left,
                                        ),
                                        trailing: new IconButton(
                                            icon: new Icon(Icons.more_vert, color: black,),
                                            onPressed: (()=>print("Boutton plus"))),
                                        subtitle:  MyText(
                                          "${recipient.numTel}",
                                          weight: FontWeight.w400,
                                          alignment: TextAlign.left,),
                                      ),
                                    )
                                ),
                              );
                            })
                        ),
                      )
                  );
                }else{
                  return EmptyScreen(titre: "Aucun bénéficiaire", subTitle: "Ajouter un bénéficiaire pour lui envoyer des fonds", image: PackageImage.Image_1,);
                }
                break;
              default:
                return Center(
                    child: Container(
                      decoration: MyGradiant(
                        startColor: baseAccent,
                        endColor: base,
                      ),
                      child: MyText("Erreur: ${snapshot.error}"),
                    )
                );
            }
          },
        )
    );
  }

  setupSub(){
    sub=DatabaseService().userCollection.where("uid", isEqualTo: user.uid).snapshots().listen((datas){
      datas.documents.forEach((docs){
        docs.reference.collection("recipients").snapshots().listen((recipients){
          recipients.documents.forEach((recipient) {
            setState(() {
              _recipientsList=Methodes().getRecipients(recipient, _recipientsList);
            });
          });
        });
      });
    });
  }
}