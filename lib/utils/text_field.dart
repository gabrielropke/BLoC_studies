import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lista_de_compras/utils/my_colors.dart';

class TypeBorder {
  static String underline = 'underline';
  static String outline = 'outline';
}

class InputFormatters {
  static String money = 'money';
}

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final Function(String)? onChanged;
  final Icon? prefixIcon;
  final IconButton? suffixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final Color? labelColor;
  final Color? hintColor;
  final String typeBorder;
  final int? maxLength;
  final String? inputFormatters;
  final String? errorText;
  const MyTextField(
      {super.key,
      required this.controller,
      required this.labelText,
      this.hintText,
      this.onChanged,
      this.prefixIcon,
      this.suffixIcon,
      this.isPassword = false,
      required this.keyboardType,
      this.labelColor,
      this.hintColor,
      required this.typeBorder,
      this.maxLength,
      this.inputFormatters, this.errorText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      inputFormatters: inputFormatters == InputFormatters.money
          ? [
              FilteringTextInputFormatter.digitsOnly,
              CurrencyInputFormatter(),
            ]
          : [],
      controller: controller,
      style: TextStyle(
        color: labelColor,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.0,
      ),
      onChanged: onChanged,
      obscureText: isPassword,
      keyboardType: keyboardType,
      maxLength: maxLength,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        labelText: labelText,
        labelStyle: TextStyle(color: labelColor, fontSize: 18),
        hintText: hintText,
        hintStyle: TextStyle(
            color: hintColor, fontSize: 16, fontWeight: FontWeight.w400),
        enabledBorder: typeBorder == TypeBorder.outline
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.0),
                borderSide: BorderSide(
                  color: MyColors().lightGray02,
                  width: 1.5,
                ),
              )
            : UnderlineInputBorder(
                borderSide: BorderSide(
                  color: MyColors().lightGray02,
                  width: 1.5,
                ),
              ),
        errorBorder: typeBorder == TypeBorder.outline
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.0),
                borderSide: BorderSide(
                  color: MyColors().red,
                  width: 1.5,
                ),
              )
            : UnderlineInputBorder(
                borderSide: BorderSide(
                  color: MyColors().red,
                  width: 1.5,
                ),
              ),
        focusedBorder: typeBorder == TypeBorder.outline
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.0),
                borderSide: BorderSide(
                  color: MyColors().purple,
                  width: 1.5,
                ),
              )
            : UnderlineInputBorder(
                borderSide: BorderSide(
                  color: MyColors().purple,
                  width: 1.5,
                ),
              ),
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: 'R\$0,00');
    }

    double value = double.parse(newValue.text.replaceAll(',', '.'));
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    String newText = formatter.format(value / 100);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
