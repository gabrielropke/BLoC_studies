// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_de_compras/authentication/pages/register/bloc/register_bloc.dart';
import 'package:lista_de_compras/authentication/pages/register/bloc/register_event.dart';
import 'package:lista_de_compras/authentication/services/model/usuario_authentication.dart';
import 'package:lista_de_compras/utils/app_routes.dart';
import 'package:lista_de_compras/utils/my_alerts.dart';

class RegisterAuthService {
  validateFields(BuildContext context, String name, String lastname,
      String email, String password) async {
    // Verifica outros campos
    if (name.isEmpty || lastname.isEmpty) {
      MyAlerts.error(context, 'Algo deu errado', 'Preencha todos os campos');
      return;
    }

    bool emailExists = await verifyEmail(email);

    if (emailExists) {
      MyAlerts.error(
          context, 'Este e-mail já está em uso', 'Faça login para continuar');
      return; // Impede que o cadastro prossiga
    }

    if (email.isEmpty || !email.contains("@")) {
      MyAlerts.error(context, 'Algo deu errado', 'E-mail inválido');
      return;
    }

    if (password.isEmpty || password.length < 6) {
      MyAlerts.error(context, 'Algo deu errado', 'A senha precisa ter pelo menos 6 caracteres');
      return;
    }

    // Se chegou até aqui, todos os campos estão validados

    Usuario usuario = Usuario();
    usuario.name = name;
    usuario.lastname = lastname;
    usuario.email = email;
    usuario.password = password;

    BlocProvider.of<RegisterBloc>(context).add(RegisterLoading(true));
    registerUser(context, usuario);
  }

  void registerUser(BuildContext context, Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .createUserWithEmailAndPassword(
            email: usuario.email, password: usuario.password)
        .then((FirebaseUser) {
      //Salvar dados do usuário
      FirebaseFirestore db = FirebaseFirestore.instance;

      db.collection("users").doc(FirebaseUser.user!.uid).set(usuario.toMap());

      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.homeRoute, (route) => false);
    }).catchError((error) {
      MyAlerts.error(
          context, 'Algo deu errado', 'Verifique os dados e tente novamente');
    });
  }

  Future<bool> verifyEmail(String email) async {
    final usersCollection = FirebaseFirestore.instance.collection('users');
    final querySnapshot =
        await usersCollection.where('email', isEqualTo: email).get();

    return querySnapshot.docs.isNotEmpty;
  }
}
