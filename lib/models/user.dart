import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_transfert/view/my_widgets/constants.dart';

class User{
  String uid;
  String name;
  String surname;
  String country;
  String imgURL;
  String numTel;
  String address;

  DocumentReference ref;
  String documentId;
  User(DocumentSnapshot snapshot){
    ref=snapshot.reference;
    documentId=snapshot.documentID;
    Map<String, dynamic> map=snapshot.data;
    uid=map[keyUid];
    name=map[keyName];
    surname=map[keySurname];
    imgURL=map[keyImgUrl];
    numTel=map[keyNumtel];
    address=map[keyAddress];
    country=map[keyCountry];
  }

  Map<String, dynamic> toMap(){
    return{
      keyUid:uid,
      keyName:name,
      keySurname:surname,
      keyAddress:address,
      keyImgUrl:imgURL,
      keyNumtel:numTel,
      keyCountry:country,
    };
  }

}