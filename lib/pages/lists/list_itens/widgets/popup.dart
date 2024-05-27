import 'package:flutter/material.dart';
import 'package:lista_de_compras/pages/lists/list_itens/bloc/list_itens_bloc.dart';
import 'package:lista_de_compras/utils/app_textstyle.dart';
import 'package:lista_de_compras/utils/my_colors.dart';
import 'package:lista_de_compras/utils/text_field.dart';

class Popup {
  static actionList(
      BuildContext context,
      String title,
      String labelText,
      String hintText,
      Function onTap,
      TextEditingController controller,
      TextInputType keyboardType,
      ListItemBloc listItemBloc,
      TextEditingController controllerNumber,
      {String? inputFormatters,
      bool invalidContext = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    titlePopup(title),
                    MyTextField(
                      inputFormatters: inputFormatters,
                      controller: controller,
                      labelText: labelText,
                      hintText: hintText,
                      keyboardType: keyboardType,
                      typeBorder: TypeBorder.underline,
                      maxLength: 26,
                    ),
                    if (invalidContext)
                      MyTextField(
                        controller: controllerNumber,
                        labelText: 'Qtd',
                        hintText: 'Ex: 3',
                        keyboardType: TextInputType.number,
                        typeBorder: TypeBorder.underline,
                        maxLength: 3,
                      ),
                    const SizedBox(height: 20),
                    optionsButton(context, onTap, invalidContext)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget titlePopup(String title) {
    return Row(
      children: [
        Icon(
          Icons.shopping_bag_rounded,
          color: MyColors().lightpurple,
        ),
        const SizedBox(width: 6),
        MyAppText.subtitle(
          title,
        ),
      ],
    );
  }

  static Widget optionsButton(
      BuildContext context, Function onTap, bool invalidContext) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: MyColors().lightGray02,
            ),
            child: Icon(Icons.close, size: 20, color: MyColors().purple),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            onTap();
            if (invalidContext) {
              Navigator.pop(context);
            }
          },
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: MyColors().lightpurple,
            ),
            child: Icon(Icons.check, size: 20, color: MyColors().white),
          ),
        ),
      ],
    );
  }
}
