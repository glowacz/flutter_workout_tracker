import 'package:flutter/services.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}

class NumberTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: removeNonDigits(newValue.text),
      selection: newValue.selection,
    );
  }
}

String capitalize(String value) {
  if(value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1)}";
}

String removeNonDigits(String value) {
  if(value.trim().isEmpty) return "";

  // String newValue = "";

  // String newValue = 
  return value.replaceAll(RegExp(r'[^0-9]'),'');

  // for(int i = 0; i < value.length; i++)
  // {
  //   if(value[i] < '9')
  //   newValue += value[i];
  // }
  // return "${value[0].toUpperCase()}${value.substring(1)}";
}