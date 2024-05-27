import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_de_compras/authentication/pages/login/bloc/login_bloc.dart';
import 'package:lista_de_compras/authentication/pages/login/bloc/login_event.dart';
import 'package:lista_de_compras/authentication/pages/login/bloc/login_state.dart';
import 'package:lista_de_compras/authentication/pages/register/register_page.dart';
import 'package:lista_de_compras/authentication/pages/reset_password/reset_password.dart';
import 'package:lista_de_compras/authentication/services/login_authentication.dart';
import 'package:lista_de_compras/utils/app_textstyle.dart';
import 'package:lista_de_compras/utils/loading.dart';
import 'package:lista_de_compras/utils/mediaquery.dart';
import 'package:lista_de_compras/utils/my_colors.dart';
import 'package:lista_de_compras/utils/text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  late LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    loginBloc = LoginBloc();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => loginBloc,
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoginInitial) {
            return LoadingWidget.progressIndication();
          }

          if (state is LoginLoaded) {
            return SizedBox(
              height: MyMediaQuery(context).height * 0.7,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(23.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    MyAppText.title('Entre com a sua conta',
                        textAlign: TextAlign.center, size: 24),
                    Opacity(
                      opacity: 0.6,
                      child: MyAppText.normal(
                        'Insira seus dados de acesso, e comece a gerenciar melhor as suas compras',
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
                    const SizedBox(height: 12),
                    MyTextField(
                      controller: controllerPassword,
                      labelText: 'Senha',
                      labelColor: Theme.of(context).colorScheme.secondary,
                      hintText: 'Insira a sua senha',
                      keyboardType: TextInputType.emailAddress,
                      typeBorder: TypeBorder.outline,
                      isPassword: state.obscureText ? true : false,
                      suffixIcon: IconButton(
                        iconSize: 20,
                        onPressed: () {
                          loginBloc.add(LoginSetVisible(
                            state.obscureText == true ? false : true,
                          ));
                        },
                        icon: Icon(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          state.obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return const ResetPasswordPage();
                          },
                        );
                        },
                        child: MyAppText.normal(
                          'Esqueceu a senha?',
                          size: 15,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: state.loadingAccount == false
                          ? () {
                              LoginAuthService().validateFields(
                                  context,
                                  controllerEmail.text,
                                  controllerPassword.text);
                            }
                          : null,
                      child: Container(
                        width: state.loadingAccount == false
                            ? double.infinity
                            : 60,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer),
                        child: Center(
                          child: state.loadingAccount == false
                              ? MyAppText.title('Entrar',
                                  color: MyColors().white)
                              : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: LoadingWidget.progressIndication(),
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    MyAppText.normal(
                      'Ainda não tem uma conta?',
                    ),
                    GestureDetector(
                      onTap: () {
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

          return LoadingWidget.progressIndication();
        },
      ),
    );
  }
}
