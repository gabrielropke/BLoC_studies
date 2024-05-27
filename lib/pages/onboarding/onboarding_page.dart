import 'package:flutter/material.dart';
import 'package:lista_de_compras/authentication/pages/login/login_page.dart';
import 'package:lista_de_compras/authentication/services/google_authentication.dart';
import 'package:lista_de_compras/pages/home/home_page.dart';
import 'package:lista_de_compras/pages/onboarding/widgets/buttons_login.dart';
import 'package:lista_de_compras/utils/app_textstyle.dart';
import 'package:lista_de_compras/utils/loading.dart';
import 'package:lista_de_compras/utils/my_colors.dart';
import 'package:lista_de_compras/utils/theme.dart';
import 'package:provider/provider.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  bool isGoogleLogin = false;

  void tapGoogleLogin() {
    setState(() {
      isGoogleLogin = true;
    });
    Future.delayed(const Duration(seconds: 6), () {
      setState(() {
        isGoogleLogin = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<bool>(
      future: GoogleAuthService().verifyUserLogged(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget.progressIndication();
        } else {
          if (snapshot.hasData && snapshot.data == true) {
            return const HomePage();
          } else {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.shopping_bag_rounded,
                              color: MyColors().darkblue,
                            ),
                            const SizedBox(width: 6),
                            MyAppText.title('Compras',
                                color: MyColors().darkblue),
                          ],
                        ),
                        IconButton(
                            onPressed: () {
                              Provider.of<ThemeProvider>(context, listen: false)
                                  .toggleTheme();
                            },
                            icon: Icon(
                                Theme.of(context).brightness == Brightness.dark
                                    ? Icons.nights_stay_outlined
                                    : Icons.wb_sunny_outlined)),
                      ],
                    ),
                    const SizedBox(height: 26),
                    Padding(
                      padding: const EdgeInsets.only(right: 42),
                      child: MyAppText.title(
                          'Gerencia suas compras diárias com o app Compras',
                          size: 30),
                    ),
                    const SizedBox(height: 6),
                    MyAppText.normal(
                        'Cuidamos para que sua compra seja bem gerenciada e resumida'),
                    const SizedBox(height: 36),
                    MyButtons.login(
                      context,
                      'assets/icons/google-icon.png',
                      'Conta Google',
                      () {
                        tapGoogleLogin();
                        GoogleAuthService().signInWithGoogle(context);
                      },
                      tapGoogleLogin: isGoogleLogin,
                    ),
                    const SizedBox(height: 12),
                    MyButtons.login(
                      context,
                      'assets/icons/e-mail-icon.png',
                      'E-mail e senha',
                      () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return const LoginPage();
                          },
                        );
                      },
                    ),
                    const Expanded(
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: Opacity(
                            opacity: 0.06,
                            child: Icon(
                              Icons.shopping_cart_checkout_rounded,
                              size: 200,
                            ),
                          )),
                    )
                  ],
                ),
              ),
            );
          }
        }
      },
    ));
  }
}
