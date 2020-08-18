
import 'package:country_pickers/countries.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectCountry extends StatefulWidget{
  @override
  _SelectCountry createState()=>new _SelectCountry();
}

class _SelectCountry extends State<SelectCountry>{
  @override
  var _isSearchOpened = false;
  var searchIndices = new List();

  void _setPreferences(String index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("countryParam", index);
  }

  @override
  void initState() {
    super.initState();
    searchIndices=countryList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Selectionez votre pays", style: new TextStyle(
          fontSize: 18.0,
        ),
        ),
      ),
      body: new NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
          ];
        },
        body: new Column(
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
              child: new Container(
                color: Colors.transparent,
                child: new Container(
                  padding: new EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(1.0, 1.0),
                        blurRadius: 3.0,
                      ),
                    ],
                  ),
                  child: new Center(
                    child: new Container(
                      child: new TextField(
                        decoration: new InputDecoration(
                          icon: Icon(Icons.search),
                          hintText: "Search (ex. Cameroun, France, Canada)",
                          border: InputBorder.none,
                        ),
                        style: new TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                          fontFamily: "Futura",
                        ),
                        onChanged: (text) {
                          setState(() {
                            if(text.isEmpty)
                              _isSearchOpened = true;
                            searchIndices= countryList.where((item) => item.name.toLowerCase().toString().contains(text.trim().toLowerCase())).toList();
                          });
                        },
                        onSubmitted: (text) {
                          var search = List();
                          if (text.isEmpty) {
                            search = countryList;
                          }
                          else {
                            search = countryList.where((item) => item.name.toLowerCase().toString().contains(text.trim().toLowerCase())).toList();
                          }
                          setState(() {
                            searchIndices= search;
                            _isSearchOpened = false;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            new Expanded(
              flex: 1,
              child: new Padding(
                padding: new EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
                child: new Container(
                  color: Colors.transparent,
                  child: new Container(
                    padding: new EdgeInsets.all(12.0),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1.0, 1.0),
                          blurRadius: 3.0,
                        ),
                      ],
                    ),
                    child: new Center(
                      child: _isSearchOpened ? new Center(
                        child: new CircularProgressIndicator(),
                      ) : new ListView.builder(
                          itemCount: searchIndices.length,
                          itemBuilder: (context, index) {
                            return new Container(
                              height: 42.0,
                              child: new GestureDetector(
                                onTap: () {
                                  _setPreferences(
                                      searchIndices[index].iso3Code);
                                  Navigator.pop(context);
                                },
                                child: new Column(
                                  children: <Widget>[
                                    new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        new Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            CountryPickerUtils.getDefaultFlagImage(CountryPickerUtils.getCountryByIso3Code(searchIndices[index].iso3Code)),
                                            new Container(
                                              width: 6.0,
                                            ),
                                            new Text(CountryPickerUtils.getCountryByIso3Code(searchIndices[index].iso3Code).phoneCode),
                                          ],
                                        ),
                                        new Text(CountryPickerUtils.getCountryByIso3Code(searchIndices[index].iso3Code).name, style: new TextStyle(
                                          fontSize: 12.0,
                                        ),
                                        ),
                                      ],
                                    ),
                                    new Divider(),
                                  ],
                                ),
                              ),
                            );
                          }
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}