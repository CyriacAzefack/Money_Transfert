
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:currency_pickers/utils/utils.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_transfert/EmptyScreen.dart';
import 'package:money_transfert/models/recipient.dart';
import 'package:money_transfert/models/transaction.dart';
import 'package:money_transfert/services/database.dart';
import 'package:money_transfert/services/methods.dart';
import 'package:money_transfert/TransactionDetails.dart';
import 'package:money_transfert/view/my_widgets/constants.dart';
import 'package:money_transfert/view/my_widgets/loading_scafold.dart';
import 'package:money_transfert/view/my_widgets/myText.dart';
import 'package:money_transfert/view/my_widgets/my_gradiant.dart';
import 'package:money_transfert/view/my_widgets/padding_with_child.dart';

import 'models/user.dart';

class TransactionsHistory extends StatefulWidget{
  @override
  _TransactionsHistory createState()=>new _TransactionsHistory();
}


class _TransactionsHistory extends State<TransactionsHistory>{

  List<UserTransaction> list=[];
  List<Recipient> recipientList=[];
  StreamSubscription sub;

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  @override
  void initState() {

    super.initState();
    setupSub();
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:StreamBuilder<QuerySnapshot>(
          stream: DatabaseService().userCollection.document(user.uid).collection("transactions").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return LoadingScaffold();
            }
            else{
              if(snapshot.data.documents.length>0){
                return Center(
                  child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: ((context, i){
                        UserTransaction transaction=list[i];
                        Recipient recipient=getRecipient(transaction.recipientId);
                        var dateFormat=new DateFormat('dd, MMM, yyyy');
                        var date=  DateTime.parse(transaction.date);
                        return Card(
                            elevation: 5.0,
                            margin: EdgeInsets.all(3.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                            child: InkWell(
                              onTap: (){
                                globalRecipient=recipient;
                                globalTransaction=transaction;
                                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                                  return new TransactionDetails();
                                }));
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 3.0, right: 3.0, top: 1.0, bottom: 1.0),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: MyText(
                                              "${dateFormat.format(date)}",
                                              color: black,
                                              weight: FontWeight.w400,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: MyText(
                                              "${transaction.status}",
                                              color: black,
                                              weight: FontWeight.w400,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        radius: 22.0,
                                        child: ClipOval(
                                          child: SizedBox(
                                              width: 44.0,
                                              height: 44.0,
                                              child: FittedBox(
                                                fit: BoxFit.fill,
                                                alignment: Alignment.center,
                                                child: CountryPickerUtils.getDefaultFlagImage(CountryPickerUtils.getCountryByName(recipient.country)),
                                              )
                                          ),
                                        ),
                                      ),
                                      title: Container(
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(
                                              child: MyText("${Methodes().capitalization(recipient.name) +" "+ Methodes().capitalization(recipient.surname)}",
                                                weight: FontWeight.w500,
                                                alignment: TextAlign.left,
                                                factor: 1.20,
                                                fontSize: 15.0,
                                                overflow: TextOverflow.ellipsis,
                                                maxLine: 1,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      trailing: Wrap(
                                        spacing: 2.0,
                                        runSpacing: 2.0,
                                        direction: Axis.vertical,
                                        alignment: WrapAlignment.spaceAround,
                                        children: <Widget>[
                                          MyText(
                                            "${double.parse(transaction.amountSend.replaceAll(',', '')).toString().replaceAllMapped(reg, mathFunc)} "+CurrencyPickerUtils.getCountryByIsoCode(CountryPickerUtils.getCountryByName(user.country).isoCode).currencyCode,
                                            color: black,
                                            weight: FontWeight.w500,
                                            alignment: TextAlign.right,
                                            factor: 1.25,
                                            fontSize: 13.0,
                                          ),
                                          MyText(
                                            "${transaction.receivedAmount.replaceAll(',', '').replaceAllMapped(reg, mathFunc)} "+CurrencyPickerUtils.getCountryByIsoCode(CountryPickerUtils.getCountryByName(recipient.country).isoCode).currencyCode,
                                            color: black,
                                            weight: FontWeight.w400,
                                            fontSize: 13.0,
                                          ),
                                        ],
                                      ),
                                      subtitle: MyText(
                                        "Orange Money",
                                        color: black,
                                        alignment: TextAlign.left,
                                        weight: FontWeight.w300,
                                        fontSize: 13.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                        );
                      })
                  ),
                );
              }
              else{
                return EmptyScreen(titre: "Aucune transaction", subTitle: "Envoyer de l'argent et vos transactions s'afficheront ici!", image: PackageImage.Image_3,);
              }
            }
          },
        ),
    );
  }



  Recipient getRecipient(String id){
    for(int i=0; i<recipientList.length; i++){
      if(recipientList[i].rid==id){
        return recipientList[i];
      }
    }
    return null;
  }

  void setupSub() {
    sub=DatabaseService().userCollection.where("uid", isEqualTo: user.uid).snapshots().listen((users){
      users.documents.forEach((user) {
        user.reference.collection('transactions').orderBy('date', descending: true).snapshots().listen((transactions) {
          transactions.documents.forEach((transaction) {
            setState(() {
              list=Methodes().getTransactions(transaction, list);
            });
            user.reference.collection('recipients').where('rid', isEqualTo: transaction.data['rid']).snapshots().listen((recipients) {
              recipients.documents.forEach((recipient) {
                setState(() {
                  recipientList=Methodes().getRecipients(recipient, recipientList);
                });
              });
            });
          });
        });
      });
    });
  }

}


class FollowTransactions extends StatefulWidget{

  @override
  _FollowTransactions createState()=>new _FollowTransactions();
}



class _FollowTransactions extends State<FollowTransactions> {


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            title: MyText("Suivre mes transactions", color: white),
        ),
        body: TransactionsHistory(),
    );
  }
}