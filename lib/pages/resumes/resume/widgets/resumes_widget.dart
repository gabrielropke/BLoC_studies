import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_compras/pages/resumes/resume/bloc/resume_bloc.dart';
import 'package:lista_de_compras/utils/app_routes.dart';
import 'package:lista_de_compras/utils/app_textstyle.dart';
import 'package:lista_de_compras/utils/loading.dart';
import 'package:lista_de_compras/utils/model/user_model.dart';
import 'package:lista_de_compras/utils/my_colors.dart';
import 'package:lista_de_compras/utils/theme.dart';
import 'package:lista_de_compras/utils/warnings.dart';
import 'package:provider/provider.dart';

class ResumesWidget extends StatefulWidget {
  final ResumeBloc resumeBloc;
  const ResumesWidget({super.key, required this.resumeBloc});

  @override
  State<ResumesWidget> createState() => _ResumesWidgetState();
}

class _ResumesWidgetState extends State<ResumesWidget> {
  @override
  Widget build(BuildContext context) {
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
            Icons.receipt_long,
            'Nada por enquanto',
          );
        }

        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: listTileWidget(
                        context,
                        data['listId'],
                        data['title'],
                        data['hour'],
                        data['itens'],
                        data['check'],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget listTileWidget(
    BuildContext context,
    String listId,
    String title,
    String hour,
    List<dynamic> itens,
    List<dynamic> check,
  ) {
    return FutureBuilder<double>(
      future: _calculateTotalPrice(listId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingWidget.progressIndication();
        }

        double totalPrice = snapshot.data!;
        return Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(
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
              ),
              title: Row(
                children: [
                  MyAppText.subtitle(
                      title[0].toUpperCase() + title.substring(1)),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    child: MyAppText.normal(
                        'R\$ ${totalPrice.toStringAsFixed(2)}'),
                  )
                ],
              ),
              subtitle: Opacity(
                opacity: 0.5,
                child: MyAppText.normal(itens.isEmpty
                    ? 'Lista vazia'
                    : check.length == itens.length
                        ? 'Sucesso'
                        : 'Pendente'),
              ),
              trailing: Opacity(
                  opacity: 0.6,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.receiptRoute,
                          arguments: {
                            'title': title,
                            'listId': listId,
                            'hour': hour,
                            'check': check,
                            'itens': itens,
                            'totalPrice': totalPrice,
                          },
                        );
                      },
                      icon: const Icon(Icons.receipt_long))),
            ),
          );
        });
      },
    );
  }

  Future<double> _calculateTotalPrice(String listId) async {
    double totalPrice = 0.0;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(UserModel.idUserLogged)
        .collection('lists')
        .doc(listId)
        .collection('itens')
        .get();

    for (var doc in querySnapshot.docs) {
      String priceStr = doc['price'];
      double price = _convertPriceToDouble(priceStr);
      totalPrice += price;
    }
    return totalPrice;
  }

  double _convertPriceToDouble(String priceStr) {
    priceStr = priceStr.replaceAll('R\$', '').trim();
    return double.tryParse(priceStr) ?? 0.0;
  }
}
