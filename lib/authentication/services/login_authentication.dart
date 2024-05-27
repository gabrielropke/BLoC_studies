// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_de_compras/authentication/pages/login/bloc/login_bloc.dart';
import 'package:lista_de_compras/authentication/pages/login/bloc/login_event.dart';
import 'package:lista_de_compras/authentication/services/model/usuario_authentication.dart';
import 'package:lista_de_compras/utils/app_routes.dart';
import 'package:lista_de_compras/utils/my_alerts.dart';


class LoginAuthService {
  void loginUser(BuildContext context, Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .signInWithEmailAndPassword(
            email: usuario.email, password: usuario.password)
        .then((FirebaseUser) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.homeRoute, (route) => false);
    }).catchError((error) {
      if (error is FirebaseAuthException &&
          (error.code == 'wrong-password' || error.code == 'user-not-found')) {
       MyAlerts.error(context, 'Algo deu errado', 'Verifique os dados e tente novamente');
      }
    });
  }

  void validateFields(BuildContext context, String email, String password) {
    if (email.isNotEmpty && email.contains("@")) {
      if (password.isNotEmpty) {
        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.password = password;

         BlocProvider.of<LoginBloc>(context).add(LoginLoading(true));
        loginUser(context, usuario);
      }
    } else {
      MyAlerts.error(context, 'Algo deu errado', 'Verifique os dados e tente novamente');
    }
  }

}
