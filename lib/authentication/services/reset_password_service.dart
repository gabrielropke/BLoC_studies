// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_compras/utils/my_alerts.dart';

class PasswordService {
  void validateFields(BuildContext context, String email) {
    if (email.isNotEmpty && email.contains('@')) {
      resetPassword(context, email);
    } else {
      MyAlerts.error(context, 'Algo deu errado',
          'Verifique os campos e tente novamente.');
    }
  }

  Future resetPassword(BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      // ignore: use_build_context_synchronously
      MyAlerts.sucess(context, 'Agora ficou fácil',
          'Enviamos para o seu e-mail o link de alteração da senha');
      // ignore: unused_catch_clause
    } on FirebaseException catch (e) {
      // ignore: use_build_context_synchronously
      MyAlerts.error(context, 'Algo deu errado',
          'Este e-mail não existe em nosso banco, verifique e tente novamente');
    }
  }
}
