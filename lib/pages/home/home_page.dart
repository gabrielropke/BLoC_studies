import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_compras/pages/home/bloc/home_bloc.dart';
import 'package:lista_de_compras/pages/home/bloc/home_state.dart';
import 'package:lista_de_compras/pages/home/widgets/baricons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_de_compras/pages/lists/list/list_page.dart';
import 'package:lista_de_compras/pages/resumes/resume/resume_page.dart';
import 'package:lista_de_compras/utils/appbar.dart';
import 'package:lista_de_compras/utils/loading.dart';
import 'package:lista_de_compras/utils/model/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeBloc homeBloc;

  Future<void> saveDataUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? userLogged = auth.currentUser;
    if (userLogged != null) {
      UserModel.idUserLogged = userLogged.uid;
      DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userLogged.uid)
          .get();
      if (userData.exists) {
        UserModel.nameUserLogged = userData['name'];
        UserModel.lastNameUserLogged = userData['lastname'];
      }
    }
  }

  @override
  void initState() {
    super.initState();
    homeBloc = HomeBloc();
    saveDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: BlocProvider(
          create: (context) => homeBloc,
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeInitial) {
                return LoadingWidget.progressIndication();
              }

              if (state is HomeLoaded) {
                return Center(
                  child: SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                            child: state.index == 0
                                ? const ResumePage()
                                : state.index == 1
                                    ? const ListPage()
                                    : state.index == 2
                                        ? Center(
                                            child: Text(
                                                'Página ${state.index + 1}'))
                                        : const SizedBox()),
                        const SizedBox(height: 16),
                        BarIconsWidget(
                          currentIndex: state.index,
                          homeBloc: homeBloc,
                        )
                      ],
                    ),
                  ),
                );
              }

              return LoadingWidget.progressIndication();
            },
          )),
    );
  }
}
