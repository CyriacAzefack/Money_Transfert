
import 'package:money_transfert/error/api_error.dart';
import 'package:money_transfert/models/convertion.dart';
import 'package:money_transfert/models/rates.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Service {
  
  String url = "https://v3.exchangerate-api.com/";
  String apiKey = "0e43490787e9c7bec7368b06";

  String get rates {
    return url + "bulk/" + apiKey + "/";
  }

  String get convertion {
    return url + "pair/" + apiKey + "/";
  }

  dynamic getRates(String string) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final currencyParam = preferences.getString(string);
    
    var url = rates + currencyParam;
    final response = await http.get(url);
    final map = json.decode(response.body);

    if (map["result"] == "success") {
      final ratesJSON = map["rates"];
      final ratesObject = new Rates.fromJson(ratesJSON);

      ratesObject.initValues();
      
      return ratesObject.rates;
    }
    else {
      final error = new ApiError.fromJson(map);
      return error;
    }
  }

  dynamic getConvertion(String string, String string2) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final currencyParam = preferences.getString(string) ?? '';
    final toParam = preferences.getString(string2) ?? '';

    var url = convertion + currencyParam + "/" + toParam;
    final response = await http.get(url);
    final map = json.decode(response.body);

    if (map["result"] == "success") {
      final convertionObject = new Convertion.fromJson(map);
      
      convertionObject.initValues();

      return convertionObject;
    }
    else {
      final error = new ApiError.fromJson(map);
      return error;
    }
  }

}