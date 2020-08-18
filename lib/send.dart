import 'package:flutter/material.dart';
import 'package:money_transfert/home.dart';
import 'package:money_transfert/services/database.dart';
import 'package:money_transfert/services/methods.dart';
import 'package:money_transfert/view/my_widgets/constants.dart';
import 'package:money_transfert/view/my_widgets/myText.dart';
import 'package:money_transfert/view/my_widgets/my_gradiant.dart';
import 'package:money_transfert/view/my_widgets/padding_with_child.dart';

class Send extends StatefulWidget{
  @override
  _Send createState() =>new _Send();
}

class _Send extends State<Send>{

  int _currentStep=0;

  VoidCallback _onStepContinue;
  VoidCallback _onStepCancel;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Confirmez vos informations d'envoie"),
        elevation: 8.0,
        backgroundColor: baseAccent,
      ),
      body: Center(
        child: Container(
          child: Stack(
            children: <Widget>[
          Stepper(
          type: StepperType.horizontal,
            currentStep: _currentStep,
            controlsBuilder: _createEventControlBuilder,
            onStepTapped: (index){
            setState(() {
              _currentStep=index;
            });
            },
            onStepContinue: () {
              setState(() {
                if(this._currentStep<this._mySteps().length-1){
                  this._currentStep=this._currentStep+1;
                }
                else{
                  DatabaseService().addTransaction(me.uid, globalRecipient.documentId, amountSend, receivedAmount, tansfertFee, totalAmount,"Enregistrer");
                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                    return new Home(me.uid);
                  }));
                }
              });
            },
            onStepCancel: () {
              setState(() {
                if(this._currentStep>0){
                  this._currentStep=this._currentStep-1;
                }else{
                  this._currentStep=0;
                }
              });
            },
            steps: _mySteps(),
          ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _bottomBar(),
              )
            ],
          ),
        )
      )
    );
  }

  Widget _createEventControlBuilder(BuildContext context,
  {VoidCallback onStepContinue, VoidCallback onStepCancel}){
    _onStepContinue=onStepContinue;
    _onStepCancel=onStepCancel;
    return SizedBox.shrink();
  }

  Widget _bottomBar(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      color: base,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            onPressed: ()=>_onStepCancel(),
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.chevron_left,
                  color: white,
                ),
                MyText(
                  "Retour",
                ),
              ],

            )
          ),
          FlatButton(
            onPressed: ()=>_onStepContinue(),
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.end,
              children: <Widget>[
                MyText(
                  "Continuer",
                ),
                Icon(
                  Icons.chevron_right,
                  color: white,
                ),
              ],

            )
          ),
        ],
      ),
    );
  }

  List<Step> _mySteps(){
    List<Step> _steps=[
      Step(
        state: StepState.editing,
          title: MyText(
            "1",
            fontSize: 18.0,
            weight: FontWeight.bold,
            color: Colors.white,
          ),
          content: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
              elevation: 5.0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 250.0,
                decoration: MyGradiant(
                    startColor: pointer,
                    endColor: base,
                    radius: 3.0,
                    horizontal: true
                ),
                child: Column(
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
                            factor:1.5,
                          ),
                        ),
                        Flexible(
                          flex: 4,
                          fit: FlexFit.loose,
                          child: MyText(
                            "${Methodes().capitalization(globalRecipient.name)+" "+Methodes().capitalization(globalRecipient.surname)}",
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
                          flex: 1,
                          child: MyText(
                            "E-mail",
                            alignment: TextAlign.start,
                            fontSize: 12.0,
                            factor:1.5,
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          flex: 4,
                          child: MyText(
                            "${globalRecipient.email}",
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
                          flex: 2,
                          child: MyText(
                            "Numéro de téléphone",
                            alignment: TextAlign.start,
                            fontSize: 12.0,
                            factor:1.5,
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          flex: 3,
                          child: MyText(
                            "${globalRecipient.numTel}",
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
                          flex: 2,
                          child: MyText(
                            "Adresse",
                            alignment: TextAlign.start,
                            fontSize: 12.0,
                            factor:1.5,
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
                            factor:1.5,
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
                            factor:1.5,
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
              )
          ),
          isActive: _currentStep==0,
      ),
      Step(
          title: new MyText(
            "2",
            fontSize: 18.0,
            weight: FontWeight.bold,
            color: Colors.white,
          ),
          content: Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 120.0,
              decoration: MyGradiant(
                  startColor: pointer,
                  endColor: base,
                  radius: 3.0,
                  horizontal: true
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PaddingWith(
                    widget: MyText(
                      "Montant Envoyé: $amountSend€",
                      fontSize: 18.0,
                      weight: FontWeight.w600,
                    ),
                    left: 3.0,
                    right: 3.0,
                    top: 1.0,
                    bottom: 1.0,
                  ),
                  PaddingWith(
                    widget: MyText(
                      "Montant Reçu: $receivedAmount FCFA",
                      fontSize: 18.0,
                      weight: FontWeight.w600,
                    ),
                    left: 3.0,
                    right: 3.0,
                    top: 1.0,
                    bottom: 1.0,
                  ),
                  PaddingWith(
                    widget: MyText(
                      "Frais De Transaction: $tansfertFee€",
                      fontSize: 18.0,
                      weight: FontWeight.w600,
                    ),
                    left: 3.0,
                    right: 3.0,
                    top: 1.0,
                    bottom: 1.0,
                  ),
                  PaddingWith(
                    widget: MyText(
                      "Montant Total à Payé: $totalAmount€",
                      fontSize: 18.0,
                      weight: FontWeight.w600,
                    ),
                    left: 3.0,
                    right: 3.0,
                    top: 1.0,
                    bottom: 1.0,
                  ),
                ],
              ),
            ),
          ),
          isActive: _currentStep==1
      ),
      Step(
          title: MyText(
            "3",
            fontSize: 18.0,
            weight: FontWeight.bold,
            color: Colors.white,
          ),
          content: Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 80.0,
              decoration: MyGradiant(
                  startColor: pointer,
                  endColor: base,
                  radius: 3.0,
                  horizontal: true
              ),

              child: PaddingWith(
                widget: MyText(
                  "Merci d'avoir utilisé Money Transfert pour votre transaction",
                  fontSize: 20.0,
                  weight: FontWeight.w400,
                ),
                left: 3.0,
                right: 3.0,
                top: 1.0,
                bottom: 1.0,
              ),
            ),
          ),
          isActive: _currentStep==2
      )
    ];
    return _steps;
  }
}

class CustomStep {
  final String title;
  final Widget page;
  CustomStep(
      {@required this.title, @required this.page});
}