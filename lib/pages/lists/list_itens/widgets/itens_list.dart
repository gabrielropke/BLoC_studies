import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lista_de_compras/pages/lists/list_itens/bloc/list_itens_bloc.dart';
import 'package:lista_de_compras/pages/lists/list_itens/bloc/list_itens_event.dart';
import 'package:lista_de_compras/pages/lists/list_itens/widgets/popup.dart';
import 'package:lista_de_compras/utils/app_textstyle.dart';
import 'package:lista_de_compras/utils/loading.dart';
import 'package:lista_de_compras/utils/model/user_model.dart';
import 'package:lista_de_compras/utils/my_colors.dart';
import 'package:lista_de_compras/utils/theme.dart';
import 'package:lista_de_compras/utils/warnings.dart';
import 'package:provider/provider.dart';

class ItensList extends StatelessWidget {
  final String listId;
  final ListItemBloc listItemBloc;
  const ItensList(
      {super.key, required this.listId, required this.listItemBloc});

  @override
  Widget build(BuildContext context) {
    TextEditingController controllerPrice = TextEditingController();
    TextEditingController controllerNumber = TextEditingController();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(UserModel.idUserLogged)
          .collection('lists')
          .doc(listId)
          .collection('itens')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget.progressIndication();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Warnings.emptyPage(
            Icons.add_shopping_cart_rounded,
            'Nenhum item adicionado',
          );
        }

        // Organize a lista em ordem decrescente com base no preço
        List<QueryDocumentSnapshot> sortedDocs = snapshot.data!.docs;
        sortedDocs.sort((a, b) {
          double priceA =
              double.parse(a['price'].substring(3).replaceAll(',', '.'));
          double priceB =
              double.parse(b['price'].substring(3).replaceAll(',', '.'));
          return priceB.compareTo(priceA);
        });

        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: ListView.builder(
            itemCount: sortedDocs.length,
            itemBuilder: (context, index) {
              var data = sortedDocs[index];

              void excludeList(BuildContext context) {
                Warnings.warningsWidget(context, () {
                  listItemBloc.excludeItem(data['itemId']);
                }, 'Apagar', 'Deseja remover este item da lista?');
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Slidable(
                    key: ValueKey(listId),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: excludeList,
                          borderRadius: BorderRadius.circular(12),
                          backgroundColor: MyColors().red,
                          foregroundColor: MyColors().white,
                          icon: Icons.remove_shopping_cart_outlined,
                        ),
                      ],
                    ),
                    child: rowBox(
                      context,
                      data['title'],
                      data['status'],
                      data['itemId'],
                      controllerPrice,
                      data['price'],
                      controllerNumber,
                      data['qtd'],
                    )),
              );
            },
          ),
        );
      },
    );
  }

  Widget rowBox(
    BuildContext context,
    String title,
    bool status,
    String itemId,
    TextEditingController controllerPrice,
    String price,
    TextEditingController controllerNumber,
    int qtd,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
              return GestureDetector(
                onTap: () {
                  listItemBloc.add(CheckItem(itemId));
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.primary),
                  child: Center(
                    child: Opacity(
                      opacity: 0.7,
                      child: status
                          ? const Icon(
                              Icons.check,
                              size: 18,
                            )
                          : null,
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(width: 12),
            MyAppText.subtitle(
              title,
              color: !status ? null : MyColors().gray,
              textDecoration: status ? TextDecoration.lineThrough : null,
            ),
            const SizedBox(width: 12),
            Opacity(
              opacity: 0.5,
              child: MyAppText.normal(
                '$qtd',
                color: !status ? null : MyColors().gray,
              ),
            ),
          ],
        ),
        if (price == "R\$ 0,00")
          IconButton(
              onPressed: () {
                Popup.actionList(
                  context,
                  'Valor',
                  'Valor',
                  'Ex: R\$219,90',
                  invalidContext: true,
                  () {
                    if (controllerNumber.text.trim().isNotEmpty &&
                        controllerPrice.text.trim().isNotEmpty) {
                      listItemBloc.add(
                        AddPrice(
                          controllerPrice.text,
                          itemId,
                          int.parse(
                            controllerNumber.text,
                          ),
                        ),
                      );
                    }
                  },
                  controllerPrice,
                  TextInputType.number,
                  listItemBloc,
                  controllerNumber,
                  inputFormatters: 'money',
                );
              },
              icon: Icon(
                Icons.attach_money,
                color: MyColors().darkblue,
              )),
        if (price != "R\$ 0,00")
          TextButton(
            onPressed: () {
              Popup.actionList(
                context,
                'Valor',
                'Valor',
                'Ex: R\$19,90',
                invalidContext: true,
                () {
                  if (controllerNumber.text.trim().isNotEmpty &&
                      controllerPrice.text.trim().isNotEmpty) {
                    listItemBloc.add(
                      AddPrice(
                        controllerPrice.text,
                        itemId,
                        int.parse(
                          controllerNumber.text,
                        ),
                      ),
                    );
                  }
                },
                controllerPrice,
                TextInputType.number,
                listItemBloc,
                controllerNumber,
                inputFormatters: 'money',
              );
            },
            child: MyAppText.subtitle(price,
                color: Theme.of(context).brightness == Brightness.dark
                    ? status
                        ? MyColors().darkGray
                        : MyColors().lightGray01
                    : status
                        ? MyColors().gray
                        : MyColors().darkGray),
          ),
      ],
    );
  }
}
