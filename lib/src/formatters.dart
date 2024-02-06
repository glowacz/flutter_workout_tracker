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

class DoubleTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: removeNonDouble(newValue.text),
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
  return value.replaceAll(RegExp(r'[^0-9]'),'');
} //RegExp(r'^\d*\.?\d{0,3}$')

String removeNonDouble(String value) {
  if(value.trim().isEmpty) return "";
  return value.replaceAll(RegExp(r'[^0-9.]'),'');
}