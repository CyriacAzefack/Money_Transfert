import 'package:flutter/material.dart';
import 'package:money_transfert/models/recipient.dart';
import 'package:money_transfert/models/transaction.dart';
import 'package:money_transfert/models/user.dart';

//Global variables
User user;
Recipient globalRecipient;
String amountSend;
String tansfertFee;
String receivedAmount;
String totalAmount;
UserTransaction globalTransaction;
String code;
//Colors
const Color white=const Color(0XFFFFFFFF);
const Color base=const Color(0xff2196f3);
const Color baseAccent=const Color(0xff2962ff);
const Color pointer=const Color(0xff00c853);
const Color black=Colors.black;


//Keys
String keyName='name';
String keyText='text';
String keySurname='surname';
String keyAddress='address';
String keyImgUrl='imgUrl';
String keyNumtel='numTel';
String keyUid='uid';
String keyRid='rid';
String keyTid='tid';
String keyNaiss='dateNaiss';
String keyAmountSend='amountSend';
String keyReceivedAmount='receivedAmount';
String keyTransactionFees='transactionFees';
String keyAmountPaid='amountPaid';
String keyStatus='status';
String keyCreationDate='date';
String keyFinishDate='finishDate';
String keyCity='city';
String keyCountry='country';
String keyEmail='email';
