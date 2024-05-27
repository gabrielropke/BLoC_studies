import 'package:flutter/material.dart';
import 'package:lista_de_compras/utils/app_textstyle.dart';
import 'package:lista_de_compras/utils/my_colors.dart';
import 'package:lista_de_compras/utils/text_field.dart';

class Warnings {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      errorTextField(BuildContext context, bool error) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: MyAppText.normal(
            error ? 'Ação realizada com sucesso' : 'Preencha todos os campos', color: MyColors().white),
        backgroundColor: error
            ? MyColors().darkGray.withOpacity(0.7)
            : MyColors().red.withOpacity(0.7),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static Widget emptyPage(IconData? icon, String text) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 60,
          color: MyColors().gray,
        ),
        MyAppText.subtitle(
          text,
          color: MyColors().gray,
        ),
      ],
    ));
  }

  static actionList(BuildContext context, String title, Function onTap,
      TextEditingController controller) {
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
                    Row(
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
                    ),
                    MyTextField(
                      controller: controller,
                      labelText: 'Nome',
                      hintText: 'Escolha um nome',
                      keyboardType: TextInputType.name,
                      typeBorder: TypeBorder.underline,
                      maxLength: 26,
                    ),
                    const SizedBox(height: 20),
                    Row(
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
                            child: Icon(Icons.close,
                                size: 20, color: MyColors().purple),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            onTap();
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: MyColors().lightpurple,
                            ),
                            child: Icon(Icons.check,
                                size: 20, color: MyColors().white),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static warningsWidget(
      BuildContext context, Function onTap, String title, String text) {
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
                    Row(
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
                    ),
                    const SizedBox(height: 20),
                    MyAppText.normal(
                      text,
                    ),
                    const SizedBox(height: 20),
                    Row(
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
                            child: Icon(Icons.close,
                                size: 20, color: MyColors().purple),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            onTap();
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: MyColors().lightpurple,
                            ),
                            child: Icon(Icons.check,
                                size: 20, color: MyColors().white),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
