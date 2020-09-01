import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:currency_pickers/utils/utils.dart';
import 'package:money_transfert/models/recipient.dart';
import 'package:money_transfert/view/my_widgets/constants.dart';

class DatabaseService{

  DatabaseService(
      {this.uid});
  final String uid;

  final CollectionReference userCollection=Firestore.instance.collection('customers');
  final notificationCollection=Firestore.instance.collection('Notifications');
  Stream<QuerySnapshot> recipientFrom(String uid)=>userCollection.document(uid).collection("recipients").snapshots();

  addNotification(String from, String to, String text){
    Map<String, dynamic> map={
      keyUid: from,
      keyText: text,
      keyCreationDate: DateTime.now().millisecondsSinceEpoch.toInt(),
    };
    notificationCollection.document(to).collection('SingleNotification').add(map);
  }

  Future signUp(String name, String surname, String address, String imgUrl, String numTel, String country) async{
    try{
      return await userCollection.document(uid).setData({
        keyName:name,
        keySurname:surname,
        keyAddress:address,
        keyImgUrl:imgUrl,
        keyNumtel:numTel,
        keyCountry:country,
        keyUid:uid,
      });
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  addRecipient(String uid, String name, String surname, String numTel, String address, String email, String city, String country,){
    var rid=userCollection.document(uid).collection("recipients").document().documentID;
    Map<String, dynamic> map={
      keyUid:uid,
      keyAddress:address,
      keyName:name,
      keySurname:surname,
      keyNumtel:numTel,
      keyEmail:email,
      keyCity:city,
      keyCountry:country,
      keyRid:name.substring(0,3)+surname.substring(0,1)+numTel.substring(0,3)+address.substring(0,2),
    };
    if(name.isNotEmpty && surname.isNotEmpty && numTel.isNotEmpty && address.isNotEmpty)
      userCollection.document(uid).collection("recipients").document(name.substring(0,3)+surname.substring(0,1)+numTel.substring(0,3)+address.substring(0,2)).setData(map);
  }

  addTransaction(String uid, String rid, String amountSend, String receivedAmount, String transactionFees, String amountPaid, String status){
    Map<String, dynamic> map={
      keyUid:uid,
      keyRid:rid,
      keyAmountSend:amountSend,
      keyReceivedAmount:receivedAmount,
      keyTransactionFees:transactionFees,
      keyAmountPaid:amountPaid,
      keyStatus:status,
      keyCreationDate:"${DateTime.now()}",
      keyFinishDate:"",
    };
    if(amountSend.isNotEmpty && receivedAmount.isNotEmpty && transactionFees.isNotEmpty && amountPaid.isNotEmpty)
      userCollection.document(uid).collection("transactions").document(CurrencyPickerUtils.getCountryByIsoCode(CountryPickerUtils.getCountryByName(globalRecipient.country).isoCode).iso3Code+DateTime.now().day.toString()+DateTime.now().month.toString()+DateTime.now().year.toString().substring(2)+DateTime.now().hour.toString()+DateTime.now().minute.toString()).setData(map);
  }

  finishTransaction(String uid, String transactionId) {
    Map<String, dynamic> map={
      keyFinishDate: "${DateTime.now()}",
      keyStatus: "Traité"
    };
    
    userCollection.document(uid).collection("transactions").document(transactionId).setData(map, merge: true);
  }



}