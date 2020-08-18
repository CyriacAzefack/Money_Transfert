import 'package:flutter/material.dart';
import 'package:money_transfert/view/my_widgets/exitConfirmationDialog.dart';

class HelperDialog{
  static exit(context, titre, text)=>showDialog(context: context, builder: (context)=>ExitConfirmationDialog(titre: titre, text: text,));
}