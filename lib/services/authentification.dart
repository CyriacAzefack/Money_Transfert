
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_transfert/services/database.dart';
import 'package:money_transfert/view/my_widgets/constants.dart';

class AuthService{
  final FirebaseAuth _auth=FirebaseAuth.instance;

  Future<FirebaseUser> signIn(String mail, String pwd, BuildContext context) async {
    try{
      // Trim the mail_address to remove the space ' ' that often appears after auto-completion
      AuthResult result =await _auth.signInWithEmailAndPassword(email: mail.trim(), password: pwd);
      FirebaseUser user=result.user;
      return user;
    }catch(e){
      if(e is PlatformException){
        switch(e.code){
          case 'ERROR_INVALID_EMAIL':
            showFlushBar(context, "Adresse mail invalide");
            break;
          case 'ERROR_USER_DISABLED':
            showFlushBar(context, "Compte utilisateur désactivé");
            break;
          case 'ERROR_USER_NOT_FOUND':
            showFlushBar(context, "Cet utilisateur n'existe pas");
            break;
          case 'ERROR_WRONG_PASSWORD':
            showFlushBar(context, "Mot de passe incorrect");
            break;
          case 'ERROR_NETWORK_REQUEST_FAILED':
            showFlushBar(context, "Vérifier votre connexion internet");
            break;
          default :
            showFlushBar(context, "Unknown Error: ${e.code}");
            break;
        }
      }
    }
  }

  Future<FirebaseUser> signUp(String name, String surname, String email, String password, String address, String imgUrl, String numTel, String country, BuildContext context) async{
    try{
      AuthResult result=await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user=result.user;
      await DatabaseService(uid:user.uid).signUp(name, surname, address,imgUrl,numTel, country);
      return user;
    }catch(e){
      if(e is PlatformException){
        switch(e.code){
          case 'ERROR_EMAIL_ALREADY_IN_USE':
            showFlushBar(context, "Adresse e-mail déja utilisée");
            break;
          case 'ERROR_INVALID_EMAIL':
            showFlushBar(context, "Adresse e-mail invalide");
            break;
          case 'ERROR_WEAK_PASSWORD':
            showFlushBar(context, "Taille du mot de passe incorrect");
            break;
        }
      }
    }
  }

  void showFlushBar(BuildContext context, String body){
    Flushbar(
      message: body,
      icon: Icon(
        Icons.error,
        color: white,
      ),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 5),
      leftBarIndicatorColor: Colors.red[700],
    )..show(context);
  }

  logOut()=>_auth.signOut();
}