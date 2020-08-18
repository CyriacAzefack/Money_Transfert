import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_transfert/models/user.dart';
import 'package:money_transfert/view/my_widgets/constants.dart';

class UserTransaction{
  String tid;
  String userId;
  String businessId;
  String recipientId;
  String amountSend;
  String receivedAmount;
  String transactionFees;
  String amountPaid;
  String date;
  String status;
  User user;

  DocumentReference ref;
  String documentId;
  UserTransaction(User users, DocumentSnapshot snapshot){
    ref=snapshot.reference;
    documentId=snapshot.documentID;
    user=users;
    Map<String, dynamic> map=snapshot.data;
    tid=map[keyTid];
    userId=map[keyUid];
    recipientId=map[keyRid];
    amountSend=map[keyAmountSend];
    receivedAmount=map[keyReceivedAmount];
    transactionFees=map[keyTransactionFees];
    amountPaid=map[keyAmountPaid];
    status=map[keyStatus];
    date=map[keyDate];
  }

  Map<String, dynamic> toMap(){
    return{
      keyUid:userId,
      keyRid:recipientId,
      keyAmountSend:amountSend,
      keyReceivedAmount:receivedAmount,
      keyTransactionFees:transactionFees,
      keyAmountPaid:amountPaid,
      keyStatus:status,
      keyDate:date,
    };
  }
}