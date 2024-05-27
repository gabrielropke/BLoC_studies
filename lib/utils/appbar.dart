import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_compras/utils/app_textstyle.dart';
import 'package:lista_de_compras/utils/my_colors.dart';
import 'package:lista_de_compras/utils/theme.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: Row(
        children: [
          Icon(
            Icons.shopping_bag_rounded,
            color: MyColors().darkblue,
          ),
          const SizedBox(width: 6),
          MyAppText.title('Compras', color: MyColors().darkblue),
        ],
      ),
      leadingWidth: 26,
      actions: [
        Row(
          children: [
            IconButton(
                onPressed: () {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme();
                },
                icon: Icon(Theme.of(context).brightness == Brightness.dark
                    ? Icons.nights_stay_outlined
                    : Icons.wb_sunny_outlined)),
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(
                Icons.exit_to_app,
                color: MyColors().red,
              ),
            ),
          ],
        )
      ],
    );
  }
}
