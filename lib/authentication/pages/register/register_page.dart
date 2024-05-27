import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_de_compras/authentication/pages/register/bloc/register_bloc.dart';
import 'package:lista_de_compras/authentication/pages/register/bloc/register_event.dart';
import 'package:lista_de_compras/authentication/pages/register/bloc/register_state.dart';
import 'package:lista_de_compras/authentication/services/register_authentication.dart';
import 'package:lista_de_compras/utils/app_textstyle.dart';
import 'package:lista_de_compras/utils/loading.dart';
import 'package:lista_de_compras/utils/mediaquery.dart';
import 'package:lista_de_compras/utils/my_colors.dart';
import 'package:lista_de_compras/utils/text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerLastname = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  late RegisterBloc registerBloc;

  @override
  void initState() {
    super.initState();
    registerBloc = RegisterBloc();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => registerBloc,
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          if (state is RegisterInitial) {
            return LoadingWidget.progressIndication();
          }

          if (state is RegisterLoaded) {
            return SizedBox(
              height: MyMediaQuery(context).height * 0.7,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(23.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    MyAppText.title('Registre-se agora',
                        textAlign: TextAlign.center, size: 24),
                    Opacity(
                      opacity: 0.6,
                      child: MyAppText.normal(
                        'crie uma conta e comece a gerenciar melhor as suas compras',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 42),
                    Row(
                      children: [
                        Expanded(
                          child: MyTextField(
                            controller: controllerName,
                            labelText: 'Nome',
                            labelColor: Theme.of(context).colorScheme.secondary,
                            hintText: 'Primeiro nome',
                            keyboardType: TextInputType.name,
                            typeBorder: TypeBorder.outline,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: MyTextField(
                            controller: controllerLastname,
                            labelText: 'Sobrenome',
                            labelColor: Theme.of(context).colorScheme.secondary,
                            hintText: 'Último nome',
                            keyboardType: TextInputType.emailAddress,
                            typeBorder: TypeBorder.outline,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
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
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        iconSize: 20,
                        onPressed: () {
                          registerBloc.add(RegisterSetVisible(
                            state.obscureText == true ? false : true,
                          ));
                        },
                        icon: Icon(
                          state.obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: state.loadingAccount == false
                          ? () {
                              RegisterAuthService().validateFields(
                                context,
                                controllerName.text,
                                controllerLastname.text,
                                controllerEmail.text,
                                controllerPassword.text,
                              );
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
                              ? MyAppText.title('Cadastrar-se',
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
                      'Já tem uma conta?',
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: MyAppText.subtitle(
                        'Entrar com minha conta',
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
