import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_compras/pages/home/home_page.dart';
import 'package:lista_de_compras/pages/lists/list_itens/list_itens_page.dart';
import 'package:lista_de_compras/pages/onboarding/onboarding_page.dart';
import 'package:lista_de_compras/pages/resumes/receipt/receipt_page.dart';
import 'package:lista_de_compras/utils/app_routes.dart';
import 'package:lista_de_compras/utils/theme.dart';
import 'package:provider/provider.dart';

// Defina o GlobalKey aqui
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final Brightness platformBrightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;

  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(platformBrightness),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    final Brightness brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    Provider.of<ThemeProvider>(context, listen: false)
        .updatePlatformBrightness(brightness);
    super.didChangePlatformBrightness();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey, // Passe o GlobalKey aqui
      title: 'Lista de Compras',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {
        AppRoutes.onboardingRoute: (context) => const OnboardingPage(),
        AppRoutes.homeRoute: (context) => const HomePage(),
        AppRoutes.itensRoute: (context) => const ListItensPage(),
        AppRoutes.receiptRoute: (context) => const ReceiptPage(),
      },
    );
  }
}
