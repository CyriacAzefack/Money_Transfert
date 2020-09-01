
import 'package:flushbar/flushbar.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_transfert/select_currency.dart';
import 'package:money_transfert/services/database.dart';
import 'package:money_transfert/services/methods.dart';
import 'package:money_transfert/view/my_widgets/constants.dart';
import 'package:money_transfert/view/my_widgets/myText.dart';
import 'package:money_transfert/view/my_widgets/my_gradiant.dart';
import 'package:money_transfert/view/my_widgets/my_textfield.dart';
import 'package:money_transfert/view/my_widgets/padding_with_child.dart';
import 'package:shared_preferences/shared_preferences.dart';

final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();

class CreateRecipient extends StatefulWidget{
  @override
  _CreateRecipient createState()=>_CreateRecipient();
}

class _CreateRecipient extends State<CreateRecipient> with RouteAware{

  TextEditingController _Cname, _Csurname, _Ctell, _Caddress, _Cemail, _Ccity;
  GlobalKey<FormState> ckey=new GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> scaffoldKey=new GlobalKey<ScaffoldState>();

  var _isConvertionLoading = true;
  var _isRatesLoading = true;
  String _code='CMR';

  void _initPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (!(preferences.getKeys().contains('add'))) {
      await preferences.setString('add', 'CMR');
    }
    setState(() {
      _isRatesLoading = true;
      _isConvertionLoading = true;
    });
  }

  Future<String> _getCurrency() async{
    SharedPreferences preferences= await SharedPreferences.getInstance();
    String currencyParam = preferences.getString('add');
    return currencyParam;
  }

  String _getDate() {
    DateTime now = new DateTime.now();
    var dateFormatter = new DateFormat('MMMM dd, yyyy');

    return dateFormatter.format(now);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPopNext() {
    setState(() {
      _isRatesLoading = true;
      _isConvertionLoading = true;
    });
  }

  @override
  void initState() {

    super.initState();
    _initPreferences();
    _code=getCode();
    _Cname=new TextEditingController();
    _Csurname=new TextEditingController();
    _Ctell=new TextEditingController();
    _Caddress=new TextEditingController();
    _Cemail=new TextEditingController();
    _Ccity=new TextEditingController();
  }

  String getCode(){

    _getCurrency().then((String value){
      setState(() {
        this._code=value;
      });
    });
    return this._code;
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _Cname.dispose();
    _Csurname.dispose();
    _Ctell.dispose();
    _Caddress.dispose();
    _Cemail.dispose();
    _Ccity.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: MyText("Ajout de bénéficiaire", color: white,),
        backgroundColor: baseAccent,
        elevation: 5,
      ),
      body: Card(
        elevation: 2.0,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              Form(
                key: ckey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    PaddingWith(top: 2.0, left: 5.0,right: 5.0,widget:MyTextField(type: TextInputType.text,formOk:(val) {return (val.isEmpty) ? "Enter un nom":null;},controller: _Cname, hint: "Nom", color1: black, color2: base, color3: base, color4: Colors.grey, icon: Icon(Icons.person), color5: base, color6: Colors.grey,),),
                    PaddingWith(top: 5.0, left: 5.0,right: 5.0,widget:MyTextField(type: TextInputType.text,formOk:(val) {return (val.isEmpty) ? "Enter un prenom":null;},controller: _Csurname, hint: "Prénom",color1: black, color2: base, color3: base, color4: Colors.grey, icon: Icon(Icons.person), color5: base, color6: Colors.grey,),),
                    PaddingWith(top: 5.0, left: 5.0,right: 5.0,widget:MyTextField(type: TextInputType.text,formOk:(val) {return (val.isEmpty) ? "Enter une adresse":null;},controller: _Caddress, hint: "Adresse",color1: black, color2: base, color3: base, color4: Colors.grey, icon: Icon(Icons.add_location), color5: base, color6: Colors.grey,),),
                    PaddingWith(top: 5.0, left: 5.0,right: 5.0,widget:MyTextField(type: TextInputType.emailAddress,formOk:(val) {return null;},controller: _Cemail, hint: "E-mail",color1: black, color2: base, color3: base, color4: Colors.grey, icon: Icon(Icons.email), color5: base, color6: Colors.grey,),),
                    PaddingWith(top: 5.0, left: 5.0,right: 5.0,widget:_buildCountryPickerDropdown()),
                    PaddingWith(top: 5.0, left: 5.0,right: 5.0,widget:MyTextField(type: TextInputType.text,formOk:(val) {return (val.isEmpty) ? "Enter une ville":null;},controller: _Ccity, hint: "Ville",color1: black, color2: base, color3: base, color4: Colors.grey, icon: Icon(Icons.location_city), color5: base, color6: Colors.grey,),),
                    PaddingWith(
                      left: 7.0,
                      right: 7.0,
                      widget: Card(
                        elevation: 7.0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50.0,
                          decoration: MyGradiant(startColor: Colors.greenAccent, endColor: pointer, radius: 5.0, horizontal: true),
                          child: FlatButton(
                            onPressed: (){
                              saveRecipients();
                            },
                            child: MyText("Enregistrer", fontSize: 20.0,weight: FontWeight.bold, color: white,),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 7.0,),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  _buildCountryPickerDropdown() {
    return MyTextField(
      icon: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SelectCurrencyPage()),
          );
        },
        child: Container(
          child:new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              PaddingWith(top: 0.0, left: 7.0, widget: CountryPickerUtils.getDefaultFlagImage(CountryPickerUtils.getCountryByIso3Code(getCode())),),
              new Container(
                width: 4.0,
              ),
              new Text("+ "+CountryPickerUtils.getCountryByIso3Code(getCode()).phoneCode, style: new TextStyle(
                fontSize: 17.0,
              ),
              ),
              new Container(
                width: 2.0,
              ),
              new Icon(Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 14.0,
              ),
            ],
          ),
          width: 120.0,
        ),
      ),
      type: TextInputType.phone,
      formOk:(val) {return (val.isEmpty) ? "Enter un numéro de téléphone":null;},
      controller: _Ctell,
      hint: "Numéro de téléphone",
      color1: black,
      color2: base,
      color3: base,
      color4: Colors.grey,
      color5: base,
      color6: Colors.grey,
    );
  }

  void saveRecipients(){
    if(ckey.currentState.validate()){
      Methodes().hideKeyboard(context);
      DatabaseService().addRecipient(user.uid, _Cname.text.toString(), _Csurname.text.toString(), "+ "+CountryPickerUtils.getCountryByIso3Code(getCode()).phoneCode+" "+_Ctell.text.toString(), _Caddress.text.toString(), _Cemail.text.toString(), _Ccity.text.toString(), CountryPickerUtils.getCountryByIso3Code(getCode()).name,);
      showCustomFlushBar(context, "${_Cname.text.toString()} ${_Csurname.text.toString()} a été ajouté à la liste de vos bénéficiaires");
      _Cname.clear();
      _Csurname.clear();
      _Ctell.clear();
      _Caddress.clear();
      _Cemail.clear();
      _Ccity.clear();
    }
  }

  void showCustomFlushBar(BuildContext context, String body){
    Flushbar(
      message: body,
      icon: Icon(
        Icons.error,
        color: white,
      ),
      backgroundColor: base,
      duration: Duration(seconds: 5),
      leftBarIndicatorColor: Colors.blue[700]
    )..show(context);
  }

}