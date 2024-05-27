import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_compras/utils/app_textstyle.dart';
import 'package:lista_de_compras/utils/loading.dart';
import 'package:lista_de_compras/utils/model/user_model.dart';
import 'package:lista_de_compras/utils/pdf/save_document.dart';
import 'package:lista_de_compras/utils/pdf/generate_pdf_api.dart';
import 'package:lista_de_compras/utils/warnings.dart';

class ItensReceipt extends StatelessWidget {
  final String listId;
  final String titleList;
  final double totalPrice;
  const ItensReceipt(
      {super.key,
      required this.listId,
      required this.titleList,
      required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(UserModel.idUserLogged)
          .collection('lists')
          .doc(listId)
          .collection('itens')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget.progressIndication();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Warnings.emptyPage(
            Icons.add_shopping_cart_rounded,
            'Nenhum item adicionado',
          );
        }

        // Organize a lista em ordem decrescente com base no preço
        List<QueryDocumentSnapshot> sortedDocs = snapshot.data!.docs;
        sortedDocs.sort((a, b) {
          double priceA =
              double.parse(a['price'].substring(3).replaceAll(',', '.'));
          double priceB =
              double.parse(b['price'].substring(3).replaceAll(',', '.'));
          return priceB.compareTo(priceA);
        });

        List<String> itemNames = [];
        List<String> itemQtd = [];
        List<String> itemPrice = [];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Theme.of(context).colorScheme.primary),
                child: ListView.builder(
                  itemCount: sortedDocs.length,
                  itemBuilder: (context, index) {
                    var data = sortedDocs[index];

                    itemNames.add(data['title']);
                    itemQtd.add(data['qtd'].toString());
                    itemPrice.add(data['price']);

                    return ListTile(
                      leading: Icon(
                        data['status']
                            ? Icons.check_circle_sharp
                            : Icons.pending_outlined,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyAppText.normal('Item:'),
                          MyAppText.normal(data['title'])
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyAppText.normal('Qtd / Valor:'),
                          MyAppText.normal('${data['qtd']} - ${data['price']}')
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Converta a lista de nomes de itens em uma string formatada
                        String itemNameString = itemNames.join('\n');
                        String itemQtdString = itemQtd.join('\n');
                        String itemPriceString = itemPrice.join('\n');

                        final generatePdf = await GeneratePdfApi.generatePdfApi(
                          titleList,
                          itemNameString,
                          itemQtdString,
                          itemPriceString,
                          '3',
                          totalPrice,
                        );
                        SaveAndOpenDocument.openPdf(generatePdf);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.secondary,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cloud_queue_rounded),
                          const SizedBox(width: 8),
                          MyAppText.normal('Baixar pdf')
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
