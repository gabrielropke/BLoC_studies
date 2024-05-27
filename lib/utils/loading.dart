import 'package:flutter/material.dart';
import 'package:lista_de_compras/utils/my_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget {
  static Widget progressIndication() {
    return Center(
        child: LoadingAnimationWidget.discreteCircle(
      color: MyColors().purple,
      size: 42,
    ));
  }
}
