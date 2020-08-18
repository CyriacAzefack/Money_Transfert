import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_transfert/view/my_widgets/constants.dart';

class MyTextField extends TextFormField{

  MyTextField({
    @required TextEditingController controller,
    TextInputType type: TextInputType.text,
    String hint:"",
    Widget icon,
    Widget icon2,
    bool obscure:false,
    String formOk(dynamic val),
    Color color1:white,
    Color color2:Colors.white,
    Color color3:Colors.white,
    Color color4:Colors.white,
    Color color5:Colors.white,
    Color color6:Colors.white,
  }):super(
      style:TextStyle(
        color: color1,
        fontSize: 15.0,
      ),
      controller: controller,
      validator:formOk,
      obscureText:obscure,
      cursorColor: color2,
      keyboardType:type,
      decoration:InputDecoration(
        labelText: hint,
        hintStyle: TextStyle(
          color: color6,
        ),
        labelStyle: TextStyle(color: (color4==Colors.white)?color4:null),
        prefixIcon: icon,
        suffixIcon: icon2,
        hintText: hint,
        border: new OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: new BorderSide(color: color3),
        ),
        enabledBorder: new OutlineInputBorder(
          borderSide: BorderSide(color: color4),
        ),
        focusedBorder: new OutlineInputBorder(
          borderSide: BorderSide(color: color5),
        ),
      ),
  );
}