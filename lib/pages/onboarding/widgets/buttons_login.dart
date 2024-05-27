import 'package:flutter/material.dart';
import 'package:lista_de_compras/utils/app_textstyle.dart';
import 'package:lista_de_compras/utils/loading.dart';
import 'package:lista_de_compras/utils/my_colors.dart';

class MyButtons {
  static Widget login(
      BuildContext context, String urlImagem, String text, Function()? onTap,
      {bool? tapGoogleLogin}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: tapGoogleLogin != null
            ? !tapGoogleLogin
                ? 220
                : 60
            : 220,
        height: 44,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.primary,
            border: Border.all(width: 1, color: MyColors().lightGray02)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          // ignore: unnecessary_null_comparison
          child: tapGoogleLogin != null
              ? !tapGoogleLogin
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(urlImagem),
                        const SizedBox(width: 10),
                        MyAppText.normal(text),
                      ],
                    )
                  : LoadingWidget.progressIndication()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(urlImagem),
                    const SizedBox(width: 10),
                    MyAppText.normal(text),
                  ],
                ),
        ),
      ),
    );
  }
}
