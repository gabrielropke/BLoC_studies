import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_de_compras/pages/lists/list/bloc/list_bloc.dart';
import 'package:lista_de_compras/pages/lists/list/bloc/list_state.dart';
import 'package:lista_de_compras/pages/lists/list/widgets/addlist.dart';
import 'package:lista_de_compras/pages/lists/list/widgets/statuslist.dart';
import 'package:lista_de_compras/utils/loading.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late ListBloc listBloc;

  @override
  void initState() {
    super.initState();
    listBloc = ListBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => listBloc,
      child: BlocBuilder<ListBloc, ListState>(
        builder: (context, state) {
          if (state is ListInitial) {
            return LoadingWidget.progressIndication();
          }

          if (state is ListLoaded) {
            return Stack(
              children: [
                ItensWidget(listBloc: listBloc),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                        padding: const EdgeInsets.only(right: 32, bottom: 12),
                        child: AddListWidget(listBloc: listBloc)))
              ],
            );
          }

          return LoadingWidget.progressIndication();
        },
      ),
    ));
  }
}
