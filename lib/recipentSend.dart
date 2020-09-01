import 'dart:collection';
import 'dart:io';

import 'package:country_pickers/country_pickers.dart';
import 'package:currency_pickers/utils/utils.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_transfert/data/service.dart';
import 'package:money_transfert/services/database.dart';
import 'package:money_transfert/services/methods.dart';
import 'package:money_transfert/view/my_widgets/constants.dart';
import 'package:money_transfert/view/my_widgets/loading_scafold.dart';
import 'package:money_transfert/view/my_widgets/myText.dart';
import 'package:money_transfert/view/my_widgets/my_gradiant.dart';
import 'package:money_transfert/view/my_widgets/padding_with_child.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import 'error/api_error.dart';
import 'Home.dart';
import 'models/convertion.dart';

final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();

class RecipientSend extends StatefulWidget {
  @override
  _RecipientSend createState() => new _RecipientSend();
}

class _RecipientSend extends State<RecipientSend> with RouteAware {

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';
  
  double tfd_s, tfd_r, frais = 0.0, total = 0.0, OM = 0.0, _Om = 0.0;
  int itemSelection = 0;
  GlobalKey<ExpandableBottomSheetState> keySheet = new GlobalKey();

  GlobalKey<FormState> key = new GlobalKey<FormState>();

  TextEditingController txtR;
  TextEditingController txtS;
  String modeDelivery = "Orange Money";
  double sender = 0.0, _om = 0.0;
  bool check = false, expand=false;
  var userCurrencyCode;
  var recipientCurrencyCode;

  dynamic preferences = SharedPreferences;

  var _isConvertionLoading = true;
  var _isRatesLoading = true;
  var _isSearchOpened = false;
  var _isKeyEntered = false;

  var service = new Service();

  var keyIndices = new List();
  var keyIndices2 = new List();

  var convertion = new Convertion();
  var rates = new LinkedHashMap();
  var rates2 = new LinkedHashMap();

  double currentValue = 1;
  double convertedValue = 0.0;
  double convertedfee = 0.0;

  void _initPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    userCurrencyCode = CurrencyPickerUtils.getCountryByIsoCode(
        CountryPickerUtils.getCountryByName(user.country).isoCode).currencyCode;

    recipientCurrencyCode = CurrencyPickerUtils.getCountryByIsoCode(
        CountryPickerUtils.getCountryByName(globalRecipient.country).isoCode)
        .currencyCode;

    preferences.setString(
        "currencyFromParam", userCurrencyCode);

    preferences.setString(
        "currencyToParam", recipientCurrencyCode);
    setState(() {
      this.preferences = preferences;
      _isRatesLoading = true;
      _isConvertionLoading = true;
      _getRates("currencyFromParam", "currencyToParam");
    });
  }

  void _getRates(String fromCurrency, String toCurrency) async {
    if (fromCurrency == "currencyFromParam") {
      final response = await service.getRates(fromCurrency);
      if (response is Map) {
        this.keyIndices.clear();
        for (var key in response.keys) {
          keyIndices.add(key);
        }

        setState(() {
          this.rates = response;
          _isRatesLoading = false;
          _getConvertion(fromCurrency, toCurrency);
        });
      } else if (response is ApiError) {
        _showDialog("Error", response.error);
      }
    } else {
      final response = await service.getRates(fromCurrency);
      if (response is Map) {
        this.keyIndices2.clear();
        for (var key in response.keys) {
          keyIndices2.add(key);
        }
        setState(() {
          this.rates2 = response;
          _isRatesLoading = false;
          _getConvertion(fromCurrency, toCurrency);
        });
      } else if (response is ApiError) {
        _showDialog("Error", response.error);
      }
    }
  }

  String _getToRateS(int index, double factor) {
    RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';

    convertedValue = double.parse(convertedValue.toStringAsFixed(5));
    var toRate = (index == 0)
        ? this.currentValue /
        655.000
        : this.currentValue /
            (convertedValue - ((convertedValue * factor) / 100));

    if (toRate.toString().length > 13) {
      toRate = double.parse(toRate.toString().substring(0, 13));
    }

    var convertedRate = (toRate.toStringAsFixed(2));

    return convertedRate.replaceAllMapped(reg, mathFunc);
  }

  String _getToRateR(int index, double factor) {
    RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';

    convertedValue = double.parse(convertedValue.toStringAsFixed(5));
    var toRate = (index == 0)
        ? this.currentValue *
        655.000
        : this.currentValue *
        (convertedValue - ((convertedValue * factor) / 100));

    if (toRate.toString().length > 13) {
      toRate = double.parse(toRate.toString().substring(0, 13));
    }

    var convertedRate = (toRate.toStringAsFixed(2));

    return convertedRate.replaceAllMapped(reg, mathFunc);
  }

  String _getToRateFee(int index, double factor) {
    RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';
    //convertedfee=double.parse(convertedfee.toStringAsFixed(5));
    var toRate = (index == 0)
        ? this.sender * (convertedfee - ((convertedfee * factor) / 100))
        : this.sender / (convertedfee - ((convertedfee * factor) / 100));

    if (toRate.toString().length > 13) {
      toRate = double.parse(toRate.toString().substring(0, 13));
    }

    var convertedRate = (toRate.toStringAsFixed(2));

    return convertedRate.replaceAllMapped(reg, mathFunc);
  }

  String _getToRateOm(int index, double factor) {
    RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';
    var toRate = (index == 0)
        ? this._om * (convertedfee - ((convertedfee * factor) / 100))
        : this._om / (convertedfee - ((convertedfee * factor) / 100));

    if (toRate.toString().length > 13) {
      toRate = double.parse(toRate.toString().substring(0, 13));
    }

    var convertedRate = (toRate.toStringAsFixed(2));

    return convertedRate.replaceAllMapped(reg, mathFunc);
  }

  void _getConvertion(String string, String string2) async {
    if (string == "currencyFromParam") {
      final response = await service.getConvertion(string, string2);
      if (response is Convertion) {
        setState(() {
          this.convertion = response;
          this.currentValue = 1;
          this.convertedValue = response.rate;

          _isKeyEntered = false;
          _isConvertionLoading = false;
        });
      } else if (response is ApiError) {
        _showDialog("Error", response.error);
      }
    } else {
      final response = await service.getConvertion(string, string2);
      if (response is Convertion) {
        setState(() {
          this.convertion = response;

          this.currentValue = 1;
          this.convertedfee = response.rate;

          _isKeyEntered = false;
          _isConvertionLoading = false;
        });
      } else if (response is ApiError) {
        _showDialog("Error", response.error);
      }
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(title),
            content: new Text(content),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPush() {}

  @override
  void didPopNext() {
    setState(() {
      _isRatesLoading = true;
      _isConvertionLoading = true;
    });
    _getRates("currencyFromParam", "currencyToParam");
    _getRates("feekey", "tofeekey");
  }

  @override
  void initState() {
    super.initState();
    initfees();
    _initPreferences();
    txtR = new TextEditingController();
    txtS = new TextEditingController();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    txtR.dispose();
    txtS.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new MyText(
            "Envoyer à ${globalRecipient.name.toUpperCase()} ${globalRecipient.surname}",
            alignment: TextAlign.left,
            weight: FontWeight.bold,
            color: Colors.white,
          ),
          actions: <Widget>[
            new Container(
              padding: EdgeInsets.only(right: 5.0),
              child: new CircleAvatar(
                backgroundColor: pointer,
                child: new InkWell(
                    onTap: null,
                    child: MyText(
                      "${globalRecipient.name.substring(0, 1)}".toUpperCase(),
                      weight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.white,
                    )),
              ),
            ),
          ],
        ),
        body: (convertedValue != 0.0)
            ? ExpandableBottomSheet(
          key: keySheet,

          animationDurationExtend: Duration(milliseconds: 400),
          animationDurationContract: Duration(milliseconds: 200),

          animationCurveExpand: Curves.bounceOut,
          animationCurveContract: Curves.ease,

          background: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: <Widget>[
                Form(
                  key: key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      PaddingWith(
                        widget: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: txtS,
                          validator: (value) {
                            return (value.isEmpty)
                                ? "Entrer un montant"
                                : null;
                          },
                          cursorColor: black.withOpacity(0.5),
                          onTap: () {
                            setState(() {
                              // txtR.clear();
                              frais = 0.0;
                              total = 0.0;
                              OM = 0.0;
                              _Om = 0.0;
                            });
                          },
                          onFieldSubmitted: (String str){
                            setState(() {
                              expand=true;
                            });
                          },
                          onChanged: ((String string) {
                            setState(() {
                              if (string.isEmpty) {
                                txtR.clear();
                                this.currentValue = 0;
                              } else {
                                if(double.parse(string.replaceAll(',', ''))*convertedValue>20000000){ // TODO: WTF is this
                                  Methodes().hideKeyboard(context);
                                  showFailedFlushBar(context, "Le montant maximum est atteint");
                                  txtR.clear();
                                  txtS.clear();
                                  frais = 0.0;
                                  total = 0.0;
                                  OM = 0.0;
                                  _Om = 0.0;
                                }else{
                                  tfd_s = double.parse(
                                      string.toString().replaceAll(',', ''));
                                  this.currentValue = tfd_s;
                                  _isKeyEntered = true;
                                  txtR.text = (CurrencyPickerUtils
                                      .getCountryByIsoCode(
                                      CountryPickerUtils
                                          .getCountryByName(
                                          user.country)
                                          .isoCode)
                                      .currencyCode ==
                                      "EUR")
                                      ? _getToRateR(0, 1).replaceAllMapped(reg, mathFunc)
                                      : _getToRateR(1, 4).replaceAllMapped(reg, mathFunc);
                                  getFees(false);
                                  total =
                                      double.parse(txtS.text.toString()) + frais + OM;
                                  check = false;
                                }
                              }
                            });
                          }),
                          style: new TextStyle(
                              color: black,
                              decorationColor: base,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500),
                          decoration: new InputDecoration(
                            labelText:
                            "${user.surname.split(" ")[0].substring(0, 1)}"
                                .toUpperCase() +
                                "${user.surname.split(" ")[0].substring(1).toLowerCase()} envoie"
                                    .toLowerCase(),
                            hintStyle: TextStyle(color: Colors.grey),
                            fillColor: black,
                            prefixIcon: PaddingWith(
                                left: 5.0,
                                right: 10.0,
                                top: 0.0,
                                widget: SizedBox(
                                  width: 3.0,
                                  height: 3.0,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: CountryPickerUtils
                                        .getDefaultFlagImage(
                                        CountryPickerUtils
                                            .getCountryByName(
                                            user.country)),
                                  ),
                                )),
                            suffixIcon: PaddingWith(
                                left: 5.0,
                                right: 10.0,
                                top: 0.0,
                                widget: SizedBox(
                                  width: 3.0,
                                  height: 3.0,
                                  child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: MyText(
                                        CurrencyPickerUtils
                                            .getCountryByIsoCode(
                                            CountryPickerUtils
                                                .getCountryByName(
                                                user.country)
                                                .isoCode)
                                            .currencyCode,
                                        weight: FontWeight.bold,
                                        factor: 1.5,
                                        color: base,
                                      )),
                                )),
                            border: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide:
                              new BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: new OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderSide: BorderSide(color: base),
                            ),
                          ),
                        ),
                        left: 10,
                        right: 10,
                        bottom: 5.0,
                        top: 10.0,
                      ),
                      PaddingWith(
                        left: 10,
                        right: 10,
                        top: 5.0,
                        widget: TextFormField(
                          controller: txtR,
                          validator: (value) {
                            return (value.isEmpty)
                                ? "Entrer un montant"
                                : null;
                          },
                          keyboardType: TextInputType.number,
                          cursorColor: black.withOpacity(0.5),
                          onTap: () {
                            setState(() {
                              frais = 0.0;
                              total = 0.0;
                              OM = 0.0;
                              _Om = 0.0;
                            });
                            // txtS.clear();
                          },
                          onFieldSubmitted: (String str){
                            setState(() {
                              expand=true;
                            });
                          },
                          onChanged: ((String string) {
                            setState(() {
                              if (string.isEmpty) {
                                txtS.clear();
                                this.currentValue = 0;
                              } else {
                                if(double.parse(string.replaceAll(',', ''))>20000000){
                                  Methodes().hideKeyboard(context);
                                  showFailedFlushBar(context, "Le montant maximum est atteind");
                                  txtR.clear();
                                  txtS.clear();
                                  frais = 0.0;
                                  total = 0.0;
                                  OM = 0.0;
                                  _Om = 0.0;
                                }else{
                                  tfd_r = double.parse(
                                      string.toString().replaceAll(',', ''));
                                  this.currentValue = tfd_r;
                                  _isKeyEntered = true;
                                  txtS.text = (CurrencyPickerUtils
                                      .getCountryByIsoCode(
                                      CountryPickerUtils
                                          .getCountryByName(
                                          user.country)
                                          .isoCode)
                                      .currencyCode ==
                                      "EUR")
                                      ? _getToRateS(0, 1).replaceAllMapped(reg, mathFunc)
                                      : _getToRateS(1, 4).replaceAllMapped(reg, mathFunc);
                                  getFees(false);
                                  total =
                                      double.parse(txtS.text.toString().replaceAll(',', '')) + frais + OM;
                                  check = false;
                                }
                              }
                            });
                          }),
                          style: new TextStyle(
                            color: black,
                            decorationColor: base,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: new InputDecoration(
                            labelText:
                            "${globalRecipient.surname.split(" ")[0].substring(0, 1)}"
                                .toUpperCase() +
                                "${globalRecipient.surname.split(" ")[0].substring(1).toLowerCase()} reçoit"
                                    .toLowerCase(),
                            fillColor: white,
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: PaddingWith(
                                left: 5.0,
                                right: 10.0,
                                top: 0.0,
                                widget: SizedBox(
                                  width: 3.0,
                                  height: 3.0,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: CountryPickerUtils
                                        .getDefaultFlagImage(
                                        CountryPickerUtils
                                            .getCountryByName(
                                            globalRecipient
                                                .country)),
                                  ),
                                )),
                            suffixIcon: PaddingWith(
                                left: 5.0,
                                right: 10.0,
                                top: 0.0,
                                widget: SizedBox(
                                  width: 3.0,
                                  height: 3.0,
                                  child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: MyText(
                                        CurrencyPickerUtils.getCountryByIsoCode(
                                            CountryPickerUtils
                                                .getCountryByName(
                                                globalRecipient
                                                    .country)
                                                .isoCode)
                                            .currencyCode,
                                        weight: FontWeight.bold,
                                        factor: 1.5,
                                        color: base,
                                      )),
                                )),
                            border: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide:
                              new BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: new OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderSide: BorderSide(color: base),
                            ),
                          ),
                        ),
                        bottom: 5.0,
                      ),
                    ],
                  ),
                ),
                PaddingWith(
                    left: 10.0,
                    right: 10.0,
                    bottom: 1.0,
                    top: 3.0,
                    widget: MyText(
                      "Taux de change 1 $userCurrencyCode = ${(userCurrencyCode == "EUR") ? 655.000 : (convertedValue - ((convertedValue * 4) / 100)).toStringAsFixed(5)}${recipientCurrencyCode}",
                      alignment: TextAlign.end,
                      fontSize: 15.0,
                    )),
                SizedBox(
                  height: 15.0,
                ),
                PaddingWith(
                    top: 0.0,
                    left: 10.0,
                    right: 10.0,
                    widget: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          MyText(
                            "Mode de paiement",
                            alignment: TextAlign.start,
                            fontSize: 15.0,
                            color: base,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          PaddingWith(
                              top: 0.0,
                              left: 5.0,
                              right: 5.0,
                              widget: Card(
                                  elevation: 3.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(5.0)),
                                  child: PaddingWith(
                                    top: 0.0,
                                    left: 5.0,
                                    widget: DropdownButton<String>(
                                      items: <String>[
                                        'Orange Money',
                                        'MTN Money'
                                      ].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: MyText(
                                            value,
                                            color: black,
                                          ),
                                        );
                                      }).toList(),
                                      hint: MyText(
                                        "Orange Money",
                                        color: black,
                                      ),
                                      onChanged: (newValue) {
                                        setState(() {
                                          modeDelivery = newValue;
                                        });
                                      },
                                      value: modeDelivery,
                                      dropdownColor: white,
                                      elevation: 3,
                                      isExpanded: true,
                                      iconEnabledColor: black,
                                      focusColor: black,
                                      //itemHeight: 5.0,
                                    ),
                                  )))
                        ],
                      ),
                    )),
                PaddingWith(
                    top: 0.0,
                    left: 15.0,
                    right: 15.0,
                    widget: Card(
                        elevation: 3.0,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              PaddingWith(
                                top: 0.0,
                                left: 5.0,
                                widget: MyText(
                                  "Payez ${_Om.toStringAsFixed(2).replaceAllMapped(reg, mathFunc)} ${userCurrencyCode} pour retrait $modeDelivery?",
                                  alignment: TextAlign.start,
                                  fontSize: 15.0,
                                  color: black,
                                ),
                              ),
                              PaddingWith(
                                top: 0.0,
                                right: 5.0,
                                widget: Align(
                                  alignment: Alignment.centerRight,
                                  child: Checkbox(
                                    value: check,
                                    activeColor: base,
                                    checkColor: base,
                                    onChanged: (bool value) {
                                      setState(() {
                                        check = value;
                                        getFees(value);
                                        total =
                                        (double.parse(txtS.text.replaceAll(',', '')) + frais + OM);
                                      });
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                    )),
                SizedBox(
                  height: 20.0,
                ),
                PaddingWith(
                    top: 0.0,
                    left: 10.0,
                    right: 10.0,
                    widget: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          MyText(
                            "Combien payez vous avec CurrencyLightning?",
                            alignment: TextAlign.start,
                            fontSize: 15.0,
                            color: base,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          PaddingWith(
                              top: 0.0,
                              left: 3.0,
                              right: 3.0,
                              widget: Card(
                                  elevation: 3.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(3.0)),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: <Widget>[
                                      ExpansionTile(
                                        title: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            MyText(
                                              "Frais de transaction",
                                              alignment: TextAlign.start,
                                              fontSize: 18.0,
                                              weight: FontWeight.bold,
                                            ),
                                            PaddingWith(
                                              top: 3.0,
                                              widget: MyText(
                                                "${(frais + OM).toStringAsFixed(2).replaceAllMapped(reg, mathFunc)}$userCurrencyCode",
                                                alignment: TextAlign.end,
                                                fontSize: 15.0,
                                                weight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                        children: <Widget>[
                                          PaddingWith(
                                            top: 0.0,
                                            left: 20.0,
                                            right: 7.0,
                                            widget: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                MyText(
                                                  "Frais de transfert",
                                                  alignment:
                                                  TextAlign.start,
                                                  fontSize: 15.0,
                                                ),
                                                MyText(
                                                  "${(frais).toStringAsFixed(2).replaceAllMapped(reg, mathFunc)}$userCurrencyCode",
                                                  alignment: TextAlign.end,
                                                  fontSize: 15.0,
                                                )
                                              ],
                                            ),
                                          ),
                                          PaddingWith(
                                            top: 3.0,
                                            left: 20.0,
                                            right: 7.0,
                                            widget: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                MyText(
                                                  "Frais $modeDelivery",
                                                  alignment:
                                                  TextAlign.start,
                                                  fontSize: 15.0,
                                                ),
                                                MyText(
                                                  "${OM.toStringAsFixed(2).replaceAllMapped(reg, mathFunc)}$userCurrencyCode",
                                                  alignment: TextAlign.end,
                                                  fontSize: 15.0,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.grey,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          Container(
                                            height: 7.0,
                                          ),
                                          MyText(
                                            "Total à payer",
                                            fontSize: 18.0,
                                          ),
                                          Container(
                                            height: 3.0,
                                          ),
                                          MyText(
                                            "${total.toStringAsFixed(2).replaceAllMapped(reg, mathFunc)} $userCurrencyCode",
                                            fontSize: 25.0,
                                            weight: FontWeight.bold,
                                            color: pointer,
                                          ),
                                          Container(
                                            height: 2.0,
                                          ),
                                        ],
                                      ),
                                    ],
                                  )))
                        ],
                      ),
                    )),
                SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ),

          persistentFooter: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              PaddingWith(
                top: 0.0,
                right: 15.0,
                widget: InkWell(
                  onTap: (){
                    setState(() {
                      (expand) ? keySheet.currentState.contract() : keySheet.currentState.expand();
                      expand = !expand;
                    });
                  },
                  child: MyText(
                    (!expand) ? "Détails" : "Réduire",
                    color: base,
                    alignment: TextAlign.right,
                  ),
                )
              ),
              PaddingWith(
                widget: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: MyGradiant(
                        startColor: baseAccent,
                        endColor: pointer,
                        radius: 3,
                        horizontal: true),
                    child: FlatButton(
                        onPressed: () {
                          if (key.currentState.validate()) {
                            amountSend = total.toStringAsFixed(2).replaceAllMapped(reg, mathFunc);
                            receivedAmount = "${(double.parse((txtR.text.isEmpty) ? "0" : txtR.text.replaceAll(',', '')) + OM*655.0)}";
                            tansfertFee = "${(frais + OM).toStringAsFixed(2).replaceAllMapped(reg, mathFunc)}";
                            totalAmount = "${total.toStringAsFixed(2).replaceAllMapped(reg, mathFunc)}";

                            String transactionSummary = "\*Transaction CURRENCY LIGHTNING\* \n" +
                                "Bénéficiaire: \*${globalRecipient.name.toUpperCase()} ${globalRecipient.surname}\* \n" +
                                "Téléphone: \*%2B${globalRecipient.numTel.replaceAll('+', '').substring(1)}\* \n" +
                                "Somme payée: \*${amountSend} EUR\* \n" +
                                "Total à recevoir: \*${receivedAmount} FCFA\* \n" +
                                "\t Crée par _${user.surname} ${user.name.toUpperCase()}_ ";


                            // print(transactionSummary);

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Confirmation de transaction"),
                                  content: Text("Valider vous cette transaction?"),
                                  actions: [
                                    FlatButton( // Annuler
                                      child: Text("Annuler"),
                                      onPressed:  () {
                                        Navigator.of(context).pop(); // dismiss dialog
                                      },
                                    ),
                                    FlatButton( // Continuer
                                      child: Text("Continuer"),
                                      onPressed:  () {
                                        DatabaseService().addTransaction(
                                            user.uid,
                                            globalRecipient.documentId,
                                            amountSend,
                                            receivedAmount,
                                            tansfertFee,
                                            totalAmount,
                                            "Enregistrer");
                                        txtR.clear();
                                        txtS.clear();

                                        // Navigator.pushAndRemoveUntil(context,
                                        //   MaterialPageRoute(
                                        //       builder: (context) => Home(user.uid)),
                                        //       (Route<dynamic> route) => false,
                                        // );
                                       Navigator.of(context).pop(); // dismiss dialog

                                        Navigator.pushAndRemoveUntil(context,
                                          MaterialPageRoute(
                                              builder: (context) => Home(user.uid)),
                                              (Route<dynamic> route) => false,
                                        );

                                       showSuccessFlushBar(context, "Votre transaction a été enregistrer avec succès");
                                       launchWhatsApp(message: transactionSummary);

                                        // transactionDoneDialog(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            ); //showDialog

                            // launchWhatsApp(message: transactionSummary);

                          }
                        },
                        child: ListTile(
                          title: MyText(
                            "Suivant",
                            fontSize: 30.0,
                            alignment: TextAlign.center,
                            weight: FontWeight.w400,
                            color: Colors.white,
                          ),
                          trailing: Icon(
                            Icons.navigate_next,
                            color: Colors.white,
                            size: 35.0,
                          ),
                        )),
                  ),
                ),
                top: 0.0,
                left: 5.0,
                right: 5.0,
              ),
              SizedBox(height: 7.0,)
            ],
          ),

          expandableContent: Container(
            height: MediaQuery.of(context).size.height/3,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                PaddingWith(
                  top: 5.0,
                  left: 20.0,
                  right: 20.0,
                  widget: Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: <Widget>[
                      MyText(
                        "Vous envoyez",
                        alignment:
                        TextAlign.start,
                        fontSize: 17.0,
                        color: Colors.grey,
                      ),
                      MyText(
                        "${double.parse((txtS.text.isEmpty) ? "0" : txtS.text.replaceAll(',', '')).toStringAsFixed(2).replaceAllMapped(reg, mathFunc)} $userCurrencyCode",
                        alignment: TextAlign.end,
                        fontSize: 15.0,
                      )
                    ],
                  ),
                ),
                PaddingWith(
                  top: 0.0,
                  left: 20.0,
                  right: 20.0,
                  widget: Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: <Widget>[
                      MyText(
                        "Taux de change",
                        alignment:
                        TextAlign.start,
                        fontSize: 17.0,
                        color: Colors.grey,
                      ),
                      MyText(
                        "1 $userCurrencyCode= ${(userCurrencyCode == "EUR") ? 655.000 : (convertedValue - ((convertedValue * 4) / 100)).toStringAsFixed(5)} $recipientCurrencyCode",
                        alignment: TextAlign.end,
                        fontSize: 15.0,
                      )
                    ],
                  ),
                ),
                PaddingWith(
                  top: 0.0,
                  left: 20.0,
                  right: 20.0,
                  widget: Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: <Widget>[
                      MyText(
                        "Frais de transaction",
                        alignment:
                        TextAlign.start,
                        fontSize: 17.0,
                        color: Colors.grey,
                      ),
                      MyText(
                        "+${(frais + OM).toStringAsFixed(2).replaceAllMapped(reg, mathFunc)} $userCurrencyCode",
                        alignment: TextAlign.end,
                        fontSize: 15.0,
                      )
                    ],
                  ),
                ),
                PaddingWith(
                  top: 0.0,
                  left: 20.0,
                  right: 20.0,
                  widget: Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: <Widget>[
                      MyText(
                        "Votre bénéficiaire recevra",
                        alignment:
                        TextAlign.start,
                        fontSize: 17.0,
                        color: Colors.grey,
                      ),
                      MyText(
                        "${double.parse((txtR.text.isEmpty) ? "0" : txtR.text.replaceAll(',', '')).toStringAsFixed(2).replaceAllMapped(reg, mathFunc)} $recipientCurrencyCode",
                        alignment: TextAlign.end,
                        fontSize: 15.0,
                      )
                    ],
                  ),
                ),
                PaddingWith(
                  left: 18,
                  right: 18,
                  top: 0.0,
                  widget: Divider(color: Colors.black,),
                ),
                PaddingWith(
                  top: 0.0,
                  left: 20.0,
                  right: 20.0,
                  widget: Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: <Widget>[
                      MyText(
                        "Total a payer",
                        alignment:
                        TextAlign.start,
                        fontSize: 20.0,
                      ),
                      MyText(
                        "${total.toStringAsFixed(2).replaceAllMapped(reg, mathFunc)} $userCurrencyCode",
                        alignment: TextAlign.end,
                        fontSize: 18.0,
                      )
                    ],
                  ),
                ),
                PaddingWith(
                  top: 0.0,
                  left: 15.0,
                  right: 15.0,
                  widget: Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: <Widget>[
                      MyText(
                        "Total à recevoir(+ frais de retrait)",
                        alignment:
                        TextAlign.start,
                        fontSize: 17.0,
                        color: Colors.grey,
                      ),
                      MyText(
                        "${(double.parse((txtR.text.isEmpty) ? "0" : txtR.text.replaceAll(',', '')) + OM*655.0).toStringAsFixed(2).replaceAllMapped(reg, mathFunc)} $recipientCurrencyCode",
                        alignment: TextAlign.end,
                        fontSize: 15.0,
                      )
                    ],
                  ),
                ),
              ],
            )
          ),
        )
            : LoadingScaffold(),
    );
  }

  void initfees() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        "feekey",
        CurrencyPickerUtils.getCountryByIsoCode(
                CountryPickerUtils.getCountryByName(user.country).isoCode)
            .currencyCode);
    sharedPreferences.setString("tofeekey", "EUR");
    _getRates("feekey", "tofeekey");
  }

  void getFees(bool om) {
    if (CurrencyPickerUtils.getCountryByIsoCode(
                CountryPickerUtils.getCountryByName(user.country).isoCode)
            .currencyCode !=
        "EUR") {
      setState(() {
        sender = double.parse(txtS.text.replaceAll(',', ''));
        _om = double.parse(txtS.text.replaceAll(',', ''));
        sender = (CurrencyPickerUtils.getCountryByIsoCode(
                        CountryPickerUtils.getCountryByName(user.country).isoCode)
                    .currencyCode ==
                "EUR")
            ? getTransactionFees(double.parse(_getToRateFee(0, 1).replaceAll(',', '')))
            : getTransactionFees(double.parse(_getToRateFee(0, 4).replaceAll(',', '')));
        _om = (CurrencyPickerUtils.getCountryByIsoCode(
                        CountryPickerUtils.getCountryByName(user.country).isoCode)
                    .currencyCode ==
                "EUR")
            ? getOrangeMoneyFees(double.parse(_getToRateOm(0, 1).replaceAll(',', '')))
            : getOrangeMoneyFees(double.parse(_getToRateOm(0, 4).replaceAll(',', '')));

        this.frais = (CurrencyPickerUtils.getCountryByIsoCode(
                        CountryPickerUtils.getCountryByName(user.country).isoCode)
                    .currencyCode ==
                "EUR")
            ? double.parse(_getToRateFee(1, 1).replaceAll(',', ''))
            : double.parse(_getToRateFee(1, 4).replaceAll(',', ''));
        this.OM = (om)
            ? ((userCurrencyCode == "EUR")
                ? double.parse(_getToRateOm(1, 1).replaceAll(',', ''))
                : double.parse(_getToRateOm(1, 4).replaceAll(',', '')))
            : 0.0;
        _Om = (userCurrencyCode ==  "EUR")
            ? double.parse(_getToRateOm(1, 1).replaceAll(',', ''))
            : double.parse(_getToRateOm(1, 4).replaceAll(',', ''));
      });
    } else {
      setState(() {
        frais = getTransactionFees(double.parse(txtS.text.replaceAll(',', '')));
        OM =
            (om) ? getOrangeMoneyFees(double.parse(txtR.text.replaceAll(',', ''))) : 0.0;
        _Om = getOrangeMoneyFees(double.parse(txtR.text.replaceAll(',', '')));
      });
    }
  }

  void showSuccessFlushBar(BuildContext context, String body){
    Flushbar(
        message: body,
        icon: Icon(
          Icons.error,
          color: white,
        ),
        backgroundColor: pointer,
        duration: Duration(seconds: 5),
        leftBarIndicatorColor: Colors.green[700]
    )..show(context);
  }

  void showFailedFlushBar(BuildContext context, String body){
    Flushbar(
      message: body,
      icon: Icon(
        Icons.error,
        color: white,
      ),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
      leftBarIndicatorColor: Colors.red[700],
    )..show(context);
  }


  double getTransactionFees(double montant) {
    // TODO : get a better function
    // if (montant != null && montant <= 757.80) {
    //   if (montant >= 0 && montant <= 14.80) {
    //     return 1.73;
    //   }
    //   if (montant >= 14.81 && montant <= 37.60) {
    //     return 2.23;
    //   }
    //   if (montant >= 37.61 && montant <= 75.20) {
    //     return 2.47;
    //   }
    //   if (montant >= 75.21 && montant <= 120.00) {
    //     return 2.93;
    //   }
    //   if (montant >= 120.1 && montant <= 149.90) {
    //     return 2.44;
    //   }
    //   if (montant >= 149.91 && montant <= 250.00) {
    //     return 2.75;
    //   }
    //   if (montant >= 250.01 && montant <= 302.00) {
    //     return 3.22;
    //   }
    //   if (montant >= 302.01 && montant <= 454.00) {
    //     return 4.22;
    //   }
    //   if (montant >= 454.01 && montant <= 550.00) {
    //     return 5.53;
    //   }
    //   if (montant >= 550.01 && montant <= 605.90) {
    //     return 5.77;
    //   }
    //   if (montant >= 605.91) {
    //     return 7.27;
    //   }
    // } else {
    //   double tmp = montant - 757.8;
    //   return getOMSend(tmp) + 7.27;
    // }
    return 1.0;
  }

  double getOrangeMoneyFees(double price) {
    var feeEdges = [6500, 10000,  13500,  25000,  50000,  80000,  100000, 200000, 300000, 400000, 500000];
    var feeValues = [0,   180,    300,    350,    700,    1350,   1800,   2150,   2600,   3100,   3600];

    var totalFee = 0.0;

    if (price < 50) {
      return 0.0;
    }

    for (var i = 0; i < feeEdges.length-1; i++) {
      if (price <= feeEdges[i].toDouble()) {
        if (i==0) {
          totalFee = price * 0.03;
        } else {
          totalFee = feeValues[i].toDouble();
        }
        break;
      }
    }

    if (totalFee == 0.0) {
      double feeLimit = feeValues[feeValues.length-1].toDouble();
      double feeEdgeLimit = feeEdges[feeEdges.length - 1].toDouble();
      totalFee = feeLimit + getOrangeMoneyFees(price - feeEdgeLimit);
    }

    return totalFee/655.0; // Convert to EUROS
  }

  double getOMTaux(double montant) {
    if (montant != null && montant <= 763.35) {
      if (montant >= 0 && montant <= 7.63) {
        return (montant * 3) / 100;
      }
      if (montant >= 8.47 && montant <= 15.27) {
        return 0.27;
      }
      if (montant >= 15.28 && montant <= 20.61) {
        return 0.46;
      }
      if (montant >= 20.62 && montant <= 38.17) {
        return 0.53;
      }
      if (montant >= 38.18 && montant <= 76.34) {
        return 1.07;
      }
      if (montant >= 76.35 && montant <= 122.14) {
        return 2.06;
      }
      if (montant >= 122.15 && montant <= 152.67) {
        return 2.75;
      }
      if (montant >= 152.68 && montant <= 305.34) {
        return 3.28;
      }
      if (montant >= 305.35 && montant <= 458.02) {
        return 3.97;
      }
      if (montant >= 458.03 && montant <= 610.69) {
        return 4.73;
      }
      if (montant >= 610.70) {
        return 5.50;
      }
    } else {
      double tmp = montant - 763.35;
      return getOMTaux(tmp) + 5.50;
    }
    return 1.0;
  }

  double getMOMOSend(double montant) {
    if (montant != null) {
      if (montant <= 15.04 && montant >= 0) {
        return 2.00;
      }
      if (montant <= 37.40 && montant >= 15.27) {
        return 2.50;
      }
      if (montant <= 74.96 && montant >= 38.17) {
        return 3.00;
      }
      if (montant <= 120.00 && montant >= 76.34) {
        return 3.50;
      }
      if (montant <= 149.77 && montant >= 122.14) {
        return 5.50;
      }
      if (montant <= 244.27 && montant >= 152.67) {
        return 6.50;
      }
      if (montant <= 301.98 && montant >= 244.28) {
        return 7.50;
      }
      if (montant <= 454.50 && montant >= 305.35) {
        return 8.50;
      }
      if (montant <= 549.62 && montant >= 458.02) {
        return 10.00;
      }
      if (montant <= 607.02 && montant >= 549.62) {
        return 11.00;
      }
      if (montant <= 759.54 && montant >= 610.69) {
        return 12.00;
      }
      if (montant < 0 && montant > 610.69) {
        return 0.0;
      }
    } else {
      return 0.0;
    }
  }

  double getMOMOTaux(double montant) {
    if (montant != null) {
      if (montant <= 15.04 && montant >= 0) {
        return 2.00;
      }
      if (montant <= 37.40 && montant >= 15.27) {
        return 2.50;
      }
      if (montant <= 74.96 && montant >= 38.17) {
        return 3.00;
      }
      if (montant <= 120.00 && montant >= 76.34) {
        return 3.50;
      }
      if (montant <= 149.77 && montant >= 122.14) {
        return 5.50;
      }
      if (montant <= 244.27 && montant >= 152.67) {
        return 6.50;
      }
      if (montant <= 301.98 && montant >= 244.28) {
        return 7.50;
      }
      if (montant <= 454.50 && montant >= 305.35) {
        return 8.50;
      }
      if (montant <= 549.62 && montant >= 458.02) {
        return 10.00;
      }
      if (montant <= 607.02 && montant >= 549.62) {
        return 11.00;
      }
      if (montant <= 759.54 && montant >= 610.69) {
        return 12.00;
      }
      if (montant < 0 && montant > 610.69) {
        return 0.0;
      }
    } else {
      return 0.0;
    }
  }
}

transactionDoneDialog(BuildContext context) {
  // set up the AlertDialog
  AssetGiffyDialog alert = AssetGiffyDialog(
    image: Image.asset(
      'assets/my_awesome_image.gif',
      fit: BoxFit.cover
    ),
    title: Text('Transaction enregistrée!',
      style: TextStyle(
          fontSize: 22.0, fontWeight: FontWeight.w600),
    ),
    description: Text('argent envoyé'),
    entryAnimation: EntryAnimation.DEFAULT,
    onlyOkButton: true,
    buttonOkText: Text('Compris!'),
    onOkButtonPressed: () {
      Navigator.of(context).pop();
    },
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void launchWhatsApp({@required String message}) async {
  String url() {
    if (Platform.isIOS) {
      return "whatsapp://wa.me/?text=${Uri.parse(message)}";
    } else {
      return "whatsapp://send?text=$message";
    }
  }
  print(url());
  if (await canLaunch(url())) {
    await launch(url());
  } else {
    throw 'Could not launch ${url()}';
  }
}