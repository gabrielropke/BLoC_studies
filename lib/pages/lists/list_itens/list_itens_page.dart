import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lista_de_compras/pages/lists/list_itens/bloc/list_itens_bloc.dart';
import 'package:lista_de_compras/pages/lists/list_itens/bloc/list_itens_event.dart';
import 'package:lista_de_compras/pages/lists/list_itens/bloc/list_itens_state.dart';
import 'package:lista_de_compras/pages/lists/list_itens/widgets/add_item.dart';
import 'package:lista_de_compras/pages/lists/list_itens/widgets/itens_list.dart';
import 'package:lista_de_compras/utils/app_routes.dart';
import 'package:lista_de_compras/utils/app_textstyle.dart';
import 'package:lista_de_compras/utils/appbar.dart';
import 'package:lista_de_compras/utils/loading.dart';
import 'package:lista_de_compras/utils/my_colors.dart';

class ListItensPage extends StatefulWidget {
  const ListItensPage({super.key});

  @override
  State<ListItensPage> createState() => _ListItensPageState();
}

class _ListItensPageState extends State<ListItensPage> {
  late ListItemBloc listItemBloc;
  late String listId;
  late String hour;
  late String progress;
  late bool status;
  late String title;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    listId = args['listId'] ?? '';
    hour = args['hour'] ?? '';
    progress = args['progress'] ?? '';
    status = args['status'] ?? '';
    title = args['title'] ?? '';
    listItemBloc = ListItemBloc(listId);
    listItemBloc.add(CalculateTotalPrice());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MyAppBar(),
        body: BlocProvider(
          create: (context) => listItemBloc,
          child: BlocBuilder<ListItemBloc, ListItemState>(
            builder: (context, state) {
              if (state is ListItemInitial) {
                return LoadingWidget.progressIndication();
              }

              if (state is ListItemLoaded) {
                return Stack(
                  children: [
                    ItensList(
                      listId: listId,
                      listItemBloc: listItemBloc,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        calculatorPrice(
                            state.totalPrice, listItemBloc.totalPrice),
                        AddIten(
                          listItemBloc: listItemBloc,
                        ),
                      ],
                    ),
                  ],
                );
              }

              return LoadingWidget.progressIndication();
            },
          ),
        ));
  }

  void reloadPage() {
    Navigator.pop(context);
    Navigator.pushNamed(
      context,
      AppRoutes.itensRoute,
      arguments: {
        'listId': listId,
        'hour': hour,
        'listItens': progress,
        'status': status,
        'title': title,
      },
    );
  }

  Widget calculatorPrice(double totalPrice, double priceBloc) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 32, bottom: 82),
        child: Stack(
          children: [
            if (priceBloc != 0.0)
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Center(
                  child: Opacity(
                    opacity: 0.7,
                    child: MyAppText.subtitle(
                      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
                          .format(totalPrice),
                    ),
                  ),
                ),
              ),
            const SizedBox(width: 12),
            if (priceBloc == 0.0)
              GestureDetector(
                onTap: () {
                  reloadPage();
                },
                child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: MyColors().purple,
                    ),
                    child: Image.asset(
                      'assets/icons/raiz-icon.png',
                      scale: 3,
                      color: MyColors().white,
                    )),
              ),
          ],
        ),
      ),
    );
  }
}
