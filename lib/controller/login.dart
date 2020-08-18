import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_transfert/services/authentification.dart';
import 'package:money_transfert/services/methods.dart';
import 'package:money_transfert/view/my_widgets/constants.dart';
import 'package:money_transfert/view/my_widgets/myText.dart';
import 'package:money_transfert/view/my_widgets/my_gradiant.dart';
import 'package:money_transfert/view/my_widgets/my_textfield.dart';
import 'package:money_transfert/view/my_widgets/padding_with_child.dart';

class Login extends StatefulWidget{
  @override
  _Login createState()=>new _Login();
}

class _Login extends State<Login>{
  TextEditingController _cmail, _cpwd;
  final AuthService _auth = new AuthService();
  final GlobalKey<FormState> _formkey=new GlobalKey<FormState>();
  bool obscure=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cmail=new TextEditingController();
    _cpwd=new TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _cmail.dispose();
    _cpwd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return new Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: (MediaQuery.of(context).size.height >= 650.0) ? MediaQuery.of(context).size.height : 650.0,
          decoration: MyGradiant(
            startColor: baseAccent,
            endColor: base,
            radius: 1.0,
          ),
          child: logView(0),
        )
    );
  }

  Widget logView(int index){
    return Form(
      key: _formkey,
      child: Column(
        children: <Widget>[
          PaddingWith(
            widget: Card(
                elevation: 7.5,
                color: base,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                child: Container(
                    margin: EdgeInsets.all(10.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: listItems(index==0),
                      ),
                    )
                )
            ),
            top: 10.0,
            left: 10.0,
            right: 10.0,
            bottom: 10.0,
          ),
          PaddingWith(
            top: 10.0,
            bottom: 10.0,
            right: 15,
            left: 15,
            widget: Card(
              elevation: 7.5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 70.0,
                decoration: MyGradiant(startColor: base, endColor: pointer, radius: 10.0, horizontal: true),
                child: FlatButton(
                  onPressed: (){
                    if(_formkey.currentState.validate()){
                      Methodes().hideKeyboard(context);
                      _auth.signIn(_cmail.text.toString(), _cpwd.text.toString(), context);
                    }
                  },
                  child: MyText("Connexion", fontSize: 25.0,weight: FontWeight.bold, color: white,),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void showFlushBar(BuildContext context, String body){
    Flushbar(
      message: body,
      icon: Icon(
        Icons.error,
        color: pointer,
      ),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: pointer,
    )..show(context);
  }

  List<Widget> listItems(bool exists){
    List<Widget> list=[];
    list.add(MyTextField(type: TextInputType.emailAddress,formOk:(val) {return (val.isEmpty) ? "Enter votre adresse mail":null;},controller: _cmail, hint: "Adresse mail",icon: Icon(Icons.mail, color: white, size: 20.0,)));
    list.add(SizedBox(height: 10.0,));
    list.add(MyTextField(type: TextInputType.visiblePassword,formOk:(val) {return (val.length<5 || val.isEmpty) ? "Le mot de passe comprend 5 caractères au minimum":null;},controller: _cpwd, hint: "Mot de passe",icon2: InkWell(onTap: obscureText, child: Icon((obscure) ? Icons.visibility_off : Icons.visibility, color: white, size: 20.0,),),icon: Icon(Icons.lock, color: white, size: 20.0,), obscure: obscure,),);
    return list;
  }

  void obscureText(){
    setState(() {
      obscure=!obscure;
    });
  }

}