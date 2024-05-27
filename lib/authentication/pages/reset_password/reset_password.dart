import 'package:flutter/material.dart';
import 'package:lista_de_compras/authentication/pages/register/register_page.dart';
import 'package:lista_de_compras/authentication/services/reset_password_service.dart';
import 'package:lista_de_compras/utils/app_textstyle.dart';
import 'package:lista_de_compras/utils/mediaquery.dart';
import 'package:lista_de_compras/utils/my_colors.dart';
import 'package:lista_de_compras/utils/text_field.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController controllerEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MyMediaQuery(context).height * 0.7,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(23.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            MyAppText.title('Vamos recuperar sua conta',
                textAlign: TextAlign.center, size: 24),
            Opacity(
              opacity: 0.6,
              child: MyAppText.normal(
                'Insira seu e-mail e enviaremos para ele o link para redefir a sua senha',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 42),
            MyTextField(
              controller: controllerEmail,
              labelText: 'E-mail',
              labelColor: Theme.of(context).colorScheme.secondary,
              hintText: 'Insira o seu e-mail',
              keyboardType: TextInputType.emailAddress,
              typeBorder: TypeBorder.outline,
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                PasswordService().validateFields(context, controllerEmail.text);
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Theme.of(context).colorScheme.secondaryContainer),
                child: Center(
                  child: MyAppText.title('Resetar', color: MyColors().white),
                ),
              ),
            ),
            const SizedBox(height: 32),
            MyAppText.normal(
              'Ainda não tem uma conta?',
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return const RegisterPage();
                  },
                );
              },
              child: MyAppText.subtitle(
                'Faça o seu cadastro!',
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
