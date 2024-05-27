import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class MyAlerts {
  static error(BuildContext context, String titulo, String desc) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      title: titulo,
      desc: desc,
      btnCancelText: 'Voltar',
      btnCancelOnPress: () {},
    ).show();
  }

  static delete(BuildContext context, String titulo, String desc,
      VoidCallback onTapCancel, VoidCallback onTapConfirm) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.infoReverse,
      title: titulo,
      desc: desc,
      btnOkText: 'Sim',
      btnOkOnPress: onTapConfirm,
      btnCancelText: 'Não',
      btnCancelOnPress: onTapCancel,
    ).show();
  }

  static sucess(BuildContext context, String titulo, String desc) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      title: titulo,
      desc: desc,
      btnOkText: 'Ok',
      btnOkOnPress: () {},
    ).show();
  }

  static warning(BuildContext context, String titulo, String desc) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      title: titulo,
      desc: desc,
      btnCancelText: 'Voltar',
      btnCancelOnPress: () {},
    ).show();
  }

  static confirm(BuildContext context, String titulo, String desc,
      VoidCallback onTapCancel, VoidCallback onTapConfirm) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      title: titulo,
      desc: desc,
      btnOkText: 'Sim',
      btnOkOnPress: onTapConfirm,
      btnCancelText: 'Não',
      btnCancelOnPress: onTapCancel,
    ).show();
  }
}
