  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_transfert/models/user.dart';
import 'package:money_transfert/view/my_widgets/constants.dart';

class Recipient{
  String rid;
  String userId;
  String name;
  String surname;
  String numTel;
  String email;
  String address;
  String city;
  String country;
  User user;
  DocumentReference ref;
  String documentId;

  Recipient(User user, DocumentSnapshot snapshot){
    ref=snapshot.reference;
    documentId=snapshot.documentID;
    user=user;
    Map<String, dynamic> map=snapshot.data;
    rid=map[keyRid];
    userId=map[keyUid];
    name=map[keyName];
    surname=map[keySurname];
    numTel=map[keyNumtel];
    address=map[keyAddress];
    email=map[keyEmail];
    city=map[keyCity];
    country=map[keyCountry];
  }

  Map<String, dynamic> toMap(){
    return{
      keyUid:userId,
      keyName:name,
      keySurname:surname,
      keyAddress:address,
      keyNumtel:numTel,
      keyEmail:email,
      keyCity:city,
      keyCountry:country,
    };
  }
}