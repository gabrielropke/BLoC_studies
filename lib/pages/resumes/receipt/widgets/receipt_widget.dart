import 'package:flutter/material.dart';
import 'package:lista_de_compras/pages/resumes/receipt/bloc/receipt_bloc.dart';
import 'package:lista_de_compras/pages/resumes/receipt/widgets/itens_receipt.dart';
import 'package:lista_de_compras/utils/app_textstyle.dart';
import 'package:lista_de_compras/utils/appbar.dart';
import 'package:lista_de_compras/utils/my_colors.dart';

class ReceiptWidget extends StatelessWidget {
  final ReceiptBloc receiptBloc;
  final String listId;
  final String title;
  final String hour;
  final List<dynamic> itens;
  final List<dynamic> check;
  final double totalPrice;
  const ReceiptWidget(
      {super.key,
      required this.receiptBloc,
      required this.listId,
      required this.title,
      required this.hour,
      required this.itens,
      required this.check,
      required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 22),
              iconTop(),
              const SizedBox(height: 22),
              MyAppText.normal(
                itens.isEmpty
                    ? 'A lista está vazia!'
                    : check.length == itens.length
                        ? 'Finalizada com sucesso'
                        : 'Contém itens pendentes',
              ),
              MyAppText.title('R\$ ${totalPrice.toStringAsFixed(2)}', size: 26),
              Divider(
                height: 60,
                indent: 26,
                endIndent: 26,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              Expanded(
                  child: ItensReceipt(
                listId: listId,
                titleList: title,
                totalPrice: totalPrice,
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconTop() {
    return ClipOval(
      child: Container(
        width: 70,
        height: 70,
        color: itens.isEmpty
            ? MyColors().red.withOpacity(0.2)
            : check.length == itens.length
                ? MyColors().green.withOpacity(0.2)
                : MyColors().yellow.withOpacity(0.2),
        child: Icon(
          itens.isEmpty
              ? Icons.warning_rounded
              : check.length == itens.length
                  ? Icons.check_circle_rounded
                  : Icons.shopping_cart_checkout,
          color: itens.isEmpty
              ? MyColors().red
              : check.length == itens.length
                  ? MyColors().green
                  : MyColors().yellow,
          size: 36,
        ),
      ),
    );
  }
}
