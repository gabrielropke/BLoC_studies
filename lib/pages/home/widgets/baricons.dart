import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lista_de_compras/pages/home/bloc/home_bloc.dart';
import 'package:lista_de_compras/pages/home/bloc/home_event.dart';
import 'package:lista_de_compras/utils/my_colors.dart';

class BarIconsWidget extends StatelessWidget {
  final int currentIndex;
  final HomeBloc homeBloc;
  const BarIconsWidget(
      {super.key, required this.currentIndex, required this.homeBloc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Platform.isAndroid
      ? const EdgeInsets.only(bottom: 22)
      : const EdgeInsets.all(0),
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            iconButton(Icons.home_filled, 0),
            iconButton(Icons.shopping_bag, 1),
          ],
        ),
      ),
    );
  }

  iconButton(IconData? icon, int index) {
    return GestureDetector(
      onTap: () {
        homeBloc.add(HomeNewIndex(newIndex: index));
      },
      child: Container(
        width: 46,
        height: 46,
        color: MyColors().transparent,
        child: Icon(icon,
            size: 20,
            color: currentIndex == index
                ? MyColors().lightpurple
                : MyColors().gray),
      ),
    );
  }
}
