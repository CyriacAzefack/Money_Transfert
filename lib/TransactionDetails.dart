
import 'package:flushbar/flushbar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:currency_pickers/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_transfert/TransactionsHistory.dart';
import 'package:money_transfert/services/database.dart';
import 'package:money_transfert/services/methods.dart';
import 'package:money_transfert/view/my_widgets/constants.dart';
import 'package:money_transfert/view/my_widgets/myText.dart';
import 'package:money_transfert/view/my_widgets/my_gradiant.dart';
import 'package:money_transfert/view/my_widgets/my_timeline.dart';
import 'package:money_transfert/view/my_widgets/padding_with_child.dart';

import 'Home.dart';


class TransactionDetails extends StatefulWidget{
  @override
  _TransactionDetails createState()=>new _TransactionDetails();
}

class _TransactionDetails extends State<TransactionDetails>{

  SliverAppBar appBar;

  var userCurrencyCode;
  var recipientCurrencyCode;
  var transactionCreationDate;
  var transactionFinishDate;
  var transactionDone = true;


  @override
  void initState() {
    super.initState();
    userCurrencyCode = CurrencyPickerUtils.getCountryByIsoCode(CountryPickerUtils.getCountryByName(user.country).isoCode).currencyCode;
    recipientCurrencyCode = CurrencyPickerUtils.getCountryByIsoCode(CountryPickerUtils.getCountryByName(globalRecipient.country).isoCode).currencyCode;

    initializeDateFormatting("fr_FR");

    DateFormat format = new DateFormat("yyyy-MM-dd HH:mm:ss");

    transactionCreationDate = format.parse(globalTransaction.creationDate);

    // Check if transaction finished
    if (globalTransaction.finishDate != null) {
      if (globalTransaction.finishDate.isNotEmpty) {
        transactionFinishDate = format.parse(globalTransaction.finishDate);
      }
      else {
        transactionDone = false;
      }
    }
    else {
      transactionDone = false;
    }

    (this.mounted) ? setup()  : null;



    // print(DateFormat.yMMMMEEEEd('fr_FR').format(transactionStartDate));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: <Widget>[
          SliverAppBar(
            snap: true,
            forceElevated: true,
            expandedHeight: kToolbarHeight,
            floating: true,
            pinned: true,
            flexibleSpace: Align(
              alignment: Alignment.centerLeft,
              child: FlexibleSpaceBar(
                centerTitle: false,
                collapseMode: CollapseMode.pin,
                title:  MyText("Envoie de ${globalTransaction.receivedAmount} $recipientCurrencyCode à ${Methodes().capitalization(globalRecipient.name)+" "+Methodes().capitalization(globalRecipient.surname)}",
                  weight: FontWeight.w700,
                  factor: 1.25,
                  color: white,
                  fontSize: 13.0,
                  alignment: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLine: 1,
                ),
              ),
            )
          ),
          SliverFillRemaining(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          PaddingWith(
                            left: 12.0,
                            widget: MyText(
                              "Statut de votre transfert",
                              alignment: TextAlign.left,
                              weight: FontWeight.w500,
                              fontSize: 20.0,
                              factor: 1.0,
                            ),
                          ),
                          Card  (
                            elevation: 5.0,
                            color: white,
                            child: new Padding(
                                padding: EdgeInsets.all(5.0),
                                child: CustomTimeline(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        new Padding(
                                            padding: new EdgeInsets.only(left: 20.0, top: 2.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                MyText(
                                                  "Commande passée",
                                                  alignment: TextAlign.start,
                                                  weight: FontWeight.w500,
                                                  factor: 1.0,
                                                ),
                                                MyText(
                                                  "${DateFormat("H'h'mm").format(transactionCreationDate)}",
                                                  alignment: TextAlign.end,
                                                  fontSize: 15.0,
                                                  weight: FontWeight.w400,
                                                )
                                              ],
                                            )
                                        ),
                                        new Padding(
                                          padding: new EdgeInsets.only(left: 25.0, top: 2.0),
                                          child: MyText(
                                            "${DateFormat.yMMMMEEEEd('fr_FR').format(transactionCreationDate)}",
                                            fontSize: 15.0,
                                            weight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        new Padding(
                                            padding: new EdgeInsets.only(left: 20.0, top: 2.0),
                                            child: MyText(
                                              "En cours de traitement",
                                              weight: FontWeight.w500,
                                              factor: 1.0,
                                            )
                                        ),
                                        new Padding(
                                          padding: new EdgeInsets.only(left: 25.0, top: 2.0),
                                          // child: MyText(
                                          //   "Mer, 12 Mai 2004",
                                          //   fontSize: 15.0,
                                          //   weight: FontWeight.w400,
                                          // ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        new Padding(
                                            padding: new EdgeInsets.only(left: 20.0, top: 2.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                MyText(
                                                  "${transactionDone ? "" : "Non"} Disponible pour retrait",
                                                  alignment: TextAlign.start,
                                                  weight: FontWeight.w500,
                                                  factor: 1.0,
                                                ),
                                                MyText(
                                                  "${transactionDone ? DateFormat("H'h'mm").format(transactionFinishDate) : ""}",
                                                  alignment: TextAlign.end,
                                                  fontSize: 15.0,
                                                  weight: FontWeight.w400,
                                                )
                                              ],
                                            )
                                        ),
                                        new Padding(
                                          padding: new EdgeInsets.only(left: 25.0, top: 2.0),
                                          child: MyText(
                                            "${transactionDone ? DateFormat.yMMMMEEEEd('fr_FR').format(transactionCreationDate) : "..."}",
                                            fontSize: 15.0,
                                            weight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  indicators: <Widget>[
                                    Container(
                                      padding: new EdgeInsets.only(),
                                      child: new Icon(Icons.fiber_manual_record, color: white,),
                                      decoration: new BoxDecoration(
                                          color: new Color(0xff00c6ff),
                                          shape: BoxShape.circle),
                                    ),
                                    Container(
                                      padding: new EdgeInsets.only(),
                                      child: new Icon(Icons.edit_attributes, color: white,),
                                      decoration: new BoxDecoration(
                                          color: new Color(0xff00c6ff),
                                          shape: BoxShape.circle),
                                    ),
                                    Container(
                                      padding: new EdgeInsets.only(),
                                      child: new Icon(Icons.check_circle, color: white,),
                                      decoration: new BoxDecoration(
                                          color: new Color(0xff00c6ff),
                                          shape: BoxShape.circle),
                                    ),
                                  ],
                                )
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          PaddingWith(
                            left: 12.0,
                            widget: MyText(
                              "Résumé",
                              alignment: TextAlign.left,
                              weight: FontWeight.w500,
                              fontSize: 20.0,
                              factor: 1.0,
                            ),
                          ),
                          Card(
                              color: white,
                              elevation: 5.0,
                              child: PaddingWith(
                                widget: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          flex: 3,
                                          fit: FlexFit.loose,
                                          child: MyText(
                                            "Numéro de transfert",
                                            alignment: TextAlign.start,
                                            fontSize: 12.0,
                                            factor: 1.25,
                                            weight: FontWeight.w500,
                                          ),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          fit: FlexFit.loose,
                                          child: MyText(
                                            "CMR2015478",
                                            alignment: TextAlign.end,
                                            fontSize: 12.0,
                                            factor: 1.25,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          fit: FlexFit.loose,
                                          flex: 3,
                                          child: MyText(
                                            "Votre bénéficiaire reçoit",
                                            alignment: TextAlign.start,
                                            fontSize: 12.0,
                                            factor:1.25,
                                            weight: FontWeight.w500,
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.loose,
                                          flex: 2,
                                          child: MyText(
                                            "${globalTransaction.receivedAmount} "+CurrencyPickerUtils.getCountryByIsoCode(CountryPickerUtils.getCountryByName(globalRecipient.country).isoCode).currencyCode,
                                            alignment: TextAlign.end,
                                            fontSize: 12.0,
                                            factor:1.25,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          fit: FlexFit.loose,
                                          flex: 3,
                                          child: MyText(
                                            "Vous avez envoyé",
                                            alignment: TextAlign.start,
                                            fontSize: 12.0,
                                            factor:1.25,
                                            weight: FontWeight.w500,
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.loose,
                                          flex: 2,
                                          child: MyText(
                                            "${globalTransaction.amountSend} "+CurrencyPickerUtils.getCountryByIsoCode(CountryPickerUtils.getCountryByName(user.country).isoCode).currencyCode,
                                            alignment: TextAlign.end,
                                            fontSize: 12.0,
                                            factor:1.25,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          fit: FlexFit.loose,
                                          flex: 3,
                                          child: MyText(
                                            "Frais de transfert",
                                            alignment: TextAlign.start,
                                            fontSize: 12.0,
                                            factor:1.25,
                                            weight: FontWeight.w500,
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.loose,
                                          flex: 2,
                                          child: MyText(
                                            "${globalTransaction.transactionFees} "+CurrencyPickerUtils.getCountryByIsoCode(CountryPickerUtils.getCountryByName(user.country).isoCode).currencyCode,
                                            alignment: TextAlign.end,
                                            fontSize: 12.0,
                                            factor:1.25,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          fit: FlexFit.loose,
                                          flex: 3,
                                          child: MyText(
                                            "Total payé",
                                            alignment: TextAlign.start,
                                            fontSize: 12.0,
                                            factor:1.25,
                                            weight: FontWeight.w500,
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.loose,
                                          flex: 2,
                                          child: MyText(
                                            "${globalTransaction.amountPaid} "+CurrencyPickerUtils.getCountryByIsoCode(CountryPickerUtils.getCountryByName(user.country).isoCode).currencyCode,
                                            alignment: TextAlign.end,
                                            fontSize: 12.0,
                                            factor:1.25,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                left: 7.0,
                                right: 7.0,
                                bottom: 7.0,
                              )
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          PaddingWith(
                            left: 12.0,
                            widget: MyText(
                              "Coordonnées du bénéficiaire",
                              alignment: TextAlign.left,
                              weight: FontWeight.w500,
                              fontSize: 20.0,
                              factor: 1.0,
                            ),
                          ),
                          Card(
                              color: white,
                              elevation: 5.0,
                              child: PaddingWith(
                                widget: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          flex: 1,
                                          fit: FlexFit.loose,
                                          child: MyText(
                                            "Nom",
                                            alignment: TextAlign.start,
                                            fontSize: 12.0,
                                            factor:1.25,
                                            weight: FontWeight.w500,
                                          ),
                                        ),
                                        Flexible(
                                          flex: 4,
                                          fit: FlexFit.loose,
                                          child: MyText(
                                            "${Methodes().capitalization(globalRecipient.name)+" "+Methodes().capitalization(globalRecipient.surname)}",
                                            alignment: TextAlign.end,
                                            fontSize: 12.0,
                                            factor:1.25,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          fit: FlexFit.loose,
                                          flex: 1,
                                          child: MyText(
                                            "E-mail",
                                            alignment: TextAlign.start,
                                            fontSize: 12.0,
                                            factor:1.25,
                                            weight: FontWeight.w500,
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.loose,
                                          flex: 4,
                                          child: MyText(
                                            "${globalRecipient.email}",
                                            alignment: TextAlign.end,
                                            fontSize: 12.0,
                                            factor:1.25,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          fit: FlexFit.loose,
                                          flex: 2,
                                          child: MyText(
                                            "Numéro de téléphone",
                                            alignment: TextAlign.start,
                                            fontSize: 12.0,
                                            factor:1.25,
                                            weight: FontWeight.w500,
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.loose,
                                          flex: 3,
                                          child: MyText(
                                            "${globalRecipient.numTel}",
                                            alignment: TextAlign.end,
                                            fontSize: 12.0,
                                            factor:1.25,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          fit: FlexFit.loose,
                                          flex: 2,
                                          child: MyText(
                                            "Adresse",
                                            alignment: TextAlign.start,
                                            fontSize: 12.0,
                                            factor:1.25,
                                            weight: FontWeight.w500,
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.loose,
                                          flex: 3,
                                          child: MyText(
                                            "${globalRecipient.address}",
                                            alignment: TextAlign.end,
                                            fontSize: 12.0,
                                            factor:1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          fit: FlexFit.loose,
                                          flex: 3,
                                          child: MyText(
                                            "Ville",
                                            alignment: TextAlign.start,
                                            fontSize: 12.0,
                                            factor:1.25,
                                            weight: FontWeight.w500,
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.loose,
                                          flex: 2,
                                          child: MyText(
                                            "${globalRecipient.city}",
                                            alignment: TextAlign.end,
                                            fontSize: 12.0,
                                            factor:1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          fit: FlexFit.loose,
                                          flex: 3,
                                          child: MyText(
                                            "Pays",
                                            alignment: TextAlign.start,
                                            fontSize: 12.0,
                                            factor:1.25,
                                            weight: FontWeight.w500,
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.loose,
                                          flex: 2,
                                          child: MyText(
                                            "${globalRecipient.country}",
                                            alignment: TextAlign.end,
                                            fontSize: 12.0,
                                            factor:1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                left: 7.0,
                                right: 7.0,
                                bottom: 7.0,
                              )
                          )
                        ],
                      ),
                    ),
                    !transactionDone ? Container(
                      width: MediaQuery.of(context).size.width/2,
                      height: 50.0,
                      decoration: MyGradiant(startColor: Colors.greenAccent, endColor: pointer, radius: 5.0, horizontal: true),
                      child: FlatButton(
                        onPressed: (){
                          // Update the transaction in the database
                          DatabaseService().finishTransaction(globalTransaction.userId, globalTransaction.documentId);
                          transactionDone = true;

                          Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(
                                builder: (context) => Home(user.uid)),
                                (Route<dynamic> route) => false,
                          );
                          showSuccessFlushBar(context, "Transaction ${globalTransaction.documentId} est disponible pour retrait");
                        },
                        child: MyText("Disponible pour retrait", fontSize: 20.0,weight: FontWeight.bold, color: white,),
                      ),
                    ) : Container(),
                    SizedBox(height: 5.0,),
                  ],
                ),
              ],
            ),
          )
        ],
      )
    );
  }

  void showSuccessFlushBar(BuildContext context, String body){
    Flushbar(
        message: body,
        icon: Icon(
          Icons.error,
          color: white,
        ),
        backgroundColor: pointer,
        duration: Duration(seconds: 5),
        leftBarIndicatorColor: Colors.green[700]
    )..show(context);
  }

  void setup() {
    DatabaseService().userCollection.document(globalTransaction.userId).collection("transactions").document(globalTransaction.documentId).get().then((transition) {
      setState(() {
        DateFormat format = new DateFormat("yyyy-MM-dd HH:mm:ss");
        // Check if transaction finished
        if (transactionDone) {
          transactionFinishDate = format.parse(transition[keyFinishDate]);
        }
      });
    });





  }

}