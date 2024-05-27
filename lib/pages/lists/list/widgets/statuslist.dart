import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lista_de_compras/pages/lists/list/bloc/list_bloc.dart';
import 'package:lista_de_compras/utils/app_routes.dart';
import 'package:lista_de_compras/utils/app_textstyle.dart';
import 'package:lista_de_compras/utils/loading.dart';
import 'package:lista_de_compras/utils/model/user_model.dart';
import 'package:lista_de_compras/utils/my_colors.dart';
import 'package:lista_de_compras/utils/theme.dart';
import 'package:lista_de_compras/utils/warnings.dart';
import 'package:provider/provider.dart';

class ItensWidget extends StatelessWidget {
  final ListBloc listBloc;
  const ItensWidget({super.key, required this.listBloc});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(UserModel.idUserLogged)
          .collection('lists')
          .orderBy('hour', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget.progressIndication();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Warnings.emptyPage(
            Icons.storefront_outlined,
            'Nenhuma lista criada',
          );
        }

        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index];

              void excludeList(BuildContext context) {
                Warnings.warningsWidget(context, () {
                  listBloc.deleteList(data['listId']);
                }, 'Apagar', 'Deseja realmente apagar esta lista?');
              }

              void updateList(BuildContext context) {
                Warnings.actionList(context, 'Alterar titulo', () {
                  listBloc.upadteList(data['listId'], controller.text);
                }, controller);
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Slidable(
                  key: ValueKey(data['listId']),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: excludeList,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                        backgroundColor: MyColors().red,
                        foregroundColor: MyColors().white,
                        icon: Icons.remove_shopping_cart_rounded,
                        label: 'Deletar',
                      ),
                      SlidableAction(
                        onPressed: updateList,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        backgroundColor: MyColors().darkblue,
                        foregroundColor: MyColors().white,
                        icon: Icons.edit_note_rounded,
                        label: 'Editar',
                      ),
                    ],
                  ),
                  child: Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return containerBox(
                        context,
                        data['title'],
                        data['itens'],
                        data['status'],
                        data['listId'],
                        data['hour'],
                        data['check'],
                      );
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget containerBox(
    BuildContext context,
    String title,
    List<dynamic> progress,
    bool status,
    String listID,
    String hour,
    List<dynamic> check,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.itensRoute,
            arguments: {
              'listId': listID,
              'hour': hour,
              'listItens': progress,
              'status': status,
              'title': title,
            },
          );
        },
        leading: Icon(
          check.isEmpty
              ? Icons.pending_outlined
              : check.length == progress.length
                  ? Icons.check_circle_rounded
                  : Icons.pending_outlined,
          color: check.isEmpty
              ? MyColors().yellow
              : check.length == progress.length
                  ? MyColors().green
                  : MyColors().yellow,
        ),
        title: MyAppText.subtitle(
          title[0].toUpperCase() + title.substring(1),
          textDecoration: check.isEmpty
              ? null
              : check.length == progress.length
                  ? TextDecoration.lineThrough
                  : null,
        ),
        subtitle: Row(
          children: [
            MyAppText.normal('${check.length}/${progress.length}'),
            Opacity(
                opacity: 0.5,
                child: MyAppText.normal(' - ${formatDataHora(hour)}'))
          ],
        ),
        trailing: const Icon(Icons.keyboard_arrow_right),
      ),
    );
  }

  String formatDataHora(String dateTimeString) {
    DateTime now = DateTime.now();
    DateTime dateTime = DateTime.parse(dateTimeString);
    Duration difference = now.difference(dateTime);

    if (difference < const Duration(minutes: 1)) {
      return 'Agora mesmo';
    } else if (difference < const Duration(minutes: 2)) {
      return 'Há ${difference.inMinutes} minuto';
    } else if (difference < const Duration(hours: 1)) {
      int minutes = difference.inMinutes;
      return 'Há $minutes ${minutes == 1 ? 'minuto' : 'minutos'}';
    } else if (difference < const Duration(days: 1)) {
      int hours = difference.inHours;
      return 'Há $hours ${hours == 1 ? 'hora' : 'horas'}';
    } else if (difference < const Duration(days: 2)) {
      return 'Há ${difference.inDays} dia';
    } else if (difference < const Duration(days: 30)) {
      return 'Há ${difference.inDays} dias';
    } else if (difference < const Duration(days: 365)) {
      int months = difference.inDays ~/ 30;
      return 'Há $months ${months == 1 ? 'mês' : 'meses'}';
    } else {
      int years = difference.inDays ~/ 365;
      return 'Há $years ${years == 1 ? 'ano' : 'anos'}';
    }
  }
}
