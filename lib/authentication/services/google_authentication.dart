// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_compras/utils/app_routes.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) {
        // O usuário cancelou a seleção de conta.
        return null;
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      User? user = userCredential.user;

      if (user != null) {
        String? nome = user.displayName;
        String? sobrenome = "";

        if (nome != null && nome.contains(" ")) {
          List<String> partesNome = nome.split(" ");
          nome = partesNome[0];
          sobrenome = partesNome.sublist(1).join(" ");
        }

        // Verifique se o documento já existe no Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection("usuarios").doc(user.uid).get();

        if (userDoc.exists) {
          // O documento já existe, navegue para a home
          Navigator.pushReplacementNamed(context, AppRoutes.homeRoute);
        } else {
          // O documento não existe, adicione os dados ao Firestore e navegue para a tela mais_dados_google
          await _firestore.collection("users").doc(user.uid).set({
            'login': 'google',
            'name': nome,
            'lastname': sobrenome,
            'email': user.email,
            'lists': [],
          });

          Navigator.pushReplacementNamed(context, AppRoutes.homeRoute);
        }

        return user;
      }
    } catch (e) {
      print("Erro durante o login com o Google: $e");
      return null;
    }
    return null;
  }

  Future<bool> verifyUserLogged() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = auth.currentUser;

    if (usuarioLogado != null) {
      return true; // Usuário logado
    } else {
      return false;
    }
  }
}
