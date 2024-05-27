import 'package:flutter/material.dart';
import 'package:lista_de_compras/pages/lists/list_itens/bloc/list_itens_bloc.dart';
import 'package:lista_de_compras/pages/lists/list_itens/bloc/list_itens_event.dart';
import 'package:lista_de_compras/pages/lists/list_itens/widgets/popup.dart';
import 'package:lista_de_compras/utils/warnings.dart';

class AddIten extends StatelessWidget {
  final ListItemBloc listItemBloc;
  const AddIten({super.key, required this.listItemBloc});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final TextEditingController controllerNumber = TextEditingController();
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 32, bottom: 82),
        child: GestureDetector(
          onTap: () {
            Popup.actionList(
              context,
              'Add item',
              'Nome',
              'Ex: Refrigerante',
              () {
                if (controller.text.trim().isEmpty) {
                  Warnings.errorTextField(context, false);
                } else {
                  listItemBloc.add(AddItem(controller.text));
                  Navigator.pop(context);
                  Warnings.errorTextField(context, true);
                }
              },
              controller,
              TextInputType.name,
              listItemBloc,
              controllerNumber,
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
              Icons.add,
              size: 20,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),
      ),
    );
  }
}
