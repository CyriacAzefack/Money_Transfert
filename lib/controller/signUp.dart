import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:money_transfert/select_country.dart';
import 'package:money_transfert/services/authentification.dart';
import 'package:money_transfert/services/methods.dart';
import 'package:money_transfert/view/my_widgets/constants.dart';
import 'package:money_transfert/view/my_widgets/myText.dart';
import 'package:money_transfert/view/my_widgets/my_gradiant.dart';
import 'package:money_transfert/view/my_widgets/my_textfield.dart';
import 'package:money_transfert/view/my_widgets/padding_with_child.dart';
import 'package:shared_preferences/shared_preferences.dart';

final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();


class SignUp extends StatefulWidget {
  @override
  _SignUp createState()=> new _SignUp();
}

class _SignUp extends State<SignUp> with RouteAware{

  TextEditingController _cmail, _cname, _csurname, _cpwd, _cpwd2, _Ctell;
  final AuthService _auth = new AuthService();
  final GlobalKey<FormState> _formkey=new GlobalKey<FormState>();
  bool obscure=true;
  bool obscure2=true;
  String _code='CMR';
  @override
  void initState() {
    super.initState();
    _getCurrency();
    _cmail=new TextEditingController();
    _Ctell=new TextEditingController();
    _cname=new TextEditingController();
    _csurname=new TextEditingController();
    _cpwd=new TextEditingController();
    _cpwd2=new TextEditingController();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }


  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _cmail.dispose();
    _cname.dispose();
    _csurname.dispose();
    _Ctell.dispose();
    _cpwd.dispose();
    _cpwd2.dispose();
    super.dispose();
  }

  Future<String> _getCurrency() async{
    SharedPreferences preferences= await SharedPreferences.getInstance();
    String currencyParam = preferences.getString('countryParam');
    return currencyParam;
  }

  String getCode(){
    _getCurrency().then((String value){
      if(this.mounted){
        setState(() {
          this._code=value;
        });
      }
    });
    return this._code;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: (MediaQuery.of(context).size.height >= 650.0) ? MediaQuery.of(context).size.height : 650.0,
          decoration: MyGradiant(
            startColor: baseAccent,
            endColor: base,
            radius: 1.0,
          ),
          child: logView(1),
        )
    );
  }

  Widget logView(int index){
    return Form(
      key: _formkey,
      child: ListView(
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
                        children: listItems(),
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
                      _auth.signUp(_cname.text.toString(), _csurname.text.toString(), _cmail.text.toString(), _cpwd.text.toString(), "", "", "+ "+CountryPickerUtils.getCountryByIso3Code(getCode()).phoneCode+" "+_Ctell.text.toString(), CountryPickerUtils.getCountryByIso3Code(getCode()).name, context);
                    }
                  },
                  child: MyText("Créer un compte", fontSize: 25.0,weight: FontWeight.bold, color: white,),
                ),
              ),
            ),
          ),
          SizedBox(height: 30.0,)
        ],
      )
    );
  }

  List<Widget> listItems(){
    List<Widget> list=[];

    list.add(MyTextField(type: TextInputType.text,formOk:(val) {return (val.isEmpty) ? "Enter votre nom":null;},controller: _cname, hint: "Nom",icon: Icon(Icons.account_circle, color: white, size: 20.0,), ));
    list.add(SizedBox(height: 10.0,));
    list.add(MyTextField(type: TextInputType.text,formOk:(val) {return (val.isEmpty) ? "Enter votre prenom":null;},controller: _csurname, hint: "Prenom",icon: Icon(Icons.account_circle, color: white, size: 20.0,)));
    list.add(SizedBox(height: 10.0,));
    list.add(MyTextField(type: TextInputType.emailAddress,formOk:(val) {return (val.isEmpty) ? "Enter votre adresse mail":null;},controller: _cmail, hint: "Adresse-mail",icon: Icon(Icons.mail, color: white, size: 20.0,)));
    list.add(SizedBox(height: 10.0,));
    list.add(_buildCountryPickerDropdown());
    list.add(SizedBox(height: 10.0,));
    list.add(MyTextField(type: TextInputType.visiblePassword,formOk:(val) {return (val.length<7 && val.isEmpty) ? "Le mot de passe comprend 7 caractères au minimum":null;},controller: _cpwd, hint: "Mot de passe",icon: Icon(Icons.lock, color: white, size: 20.0,), obscure: obscure,icon2: InkWell(onTap: obscureText, child: Icon((obscure) ? Icons.visibility_off : Icons.visibility, color: white, size: 20.0,),),));
    list.add(SizedBox(height: 10.0,));
    list.add(MyTextField(type: TextInputType.visiblePassword,formOk:(val) {return (val.toString()!=_cpwd.text.toString() || val.isEmpty) ? "Veillez confirmer le mot de passe":null;},controller: _cpwd2, hint: "Confimez le mot de passe",icon: Icon(Icons.lock, color: white, size: 20.0,), obscure: obscure2,icon2: InkWell(onTap: obscureText2, child: Icon((obscure2) ? Icons.visibility_off : Icons.visibility, color: white, size: 20.0,),),));
    list.add(SizedBox(height: 20.0,));

    return list;
  }

  void obscureText(){
    setState(() {
      obscure=!obscure;
    });
  }
  void obscureText2(){
    setState(() {
      obscure2=!obscure2;
    });
  }

  _buildCountryPickerDropdown() {
    return MyTextField(
      icon: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (BuildContext context) =>new  SelectCountry()),
          );
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 110,
            maxHeight: 10
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              PaddingWith(top: 2,bottom: 2, left: 7.0, widget: CountryPickerUtils.getDefaultFlagImage(CountryPickerUtils.getCountryByIso3Code(getCode().toLowerCase().toString())),),
              new Container(
                width: 4.0,
              ),
              new Text("+ "+CountryPickerUtils.getCountryByIso3Code(getCode().toLowerCase().toString()).phoneCode, style: new TextStyle(
                  fontSize: 17.0,
                  color: white
              ),
              ),
              new Container(
                width: 2.0,
              ),
              new Icon(Icons.arrow_forward_ios,
                color: white,
                size: 14.0,
              ),
            ],
          ),
        )
      ),
      type: TextInputType.phone,
      formOk:(val) {return (val.isEmpty) ? "Enter un numéro de téléphone":null;},
      controller: _Ctell,
      hint: "Numéro de téléphone",
    );
  }

}