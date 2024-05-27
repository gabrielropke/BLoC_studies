import 'package:flutter/material.dart';
import 'package:lista_de_compras/pages/lists/list/bloc/list_bloc.dart';
import 'package:lista_de_compras/pages/lists/list/bloc/list_event.dart';
import 'package:lista_de_compras/utils/warnings.dart';

class AddListWidget extends StatelessWidget {
  final ListBloc listBloc;
  const AddListWidget({super.key, required this.listBloc});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return GestureDetector(
      onTap: () {
        Warnings.actionList(
          context,
          'Criar Lista',
          () {
            if (controller.text.isNotEmpty) {
              listBloc.add(AddNewList(newItemList: controller.text));
              Navigator.pop(context);
              Warnings.errorTextField(context, true);
            } else {
              Warnings.errorTextField(context, false);
            }
          },
          controller,
        );
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Icon(
          Icons.add_shopping_cart_rounded,
          size: 20,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
