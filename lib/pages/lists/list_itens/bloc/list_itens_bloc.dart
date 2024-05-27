// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_de_compras/pages/lists/list_itens/bloc/list_itens_event.dart';
import 'package:lista_de_compras/pages/lists/list_itens/bloc/list_itens_state.dart';
import 'package:lista_de_compras/utils/model/user_model.dart';

class ListItemBloc extends Bloc<ListItemEvent, ListItemState> {
  final String listId;
  double totalPrice = 0.0;
  ListItemBloc(this.listId) : super(ListItemInitial()) {
    checkListEmpty(listId);

    on<AddItem>(
      (event, emit) {
        createItem(event.name);
      },
    );

    on<CheckItem>(
      (event, emit) {
        checkItem(event.itemId);
      },
    );

    on<AddPrice>(
      (event, emit) {
        addPrice(event.price, event.itemId, event.qtd);
      },
    );

    on<CalculateTotalPrice>(
      (event, emit) {
        calculateTotalPrice();
      },
    );

    on<ExcludeItem>(
      (event, emit) {
        excludeItem(event.itemId);
      },
    );
  }

  Future<void> calculateTotalPrice() async {
    CollectionReference itensCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(UserModel.idUserLogged)
        .collection('lists')
        .doc(listId)
        .collection('itens');

    QuerySnapshot querySnapshot = await itensCollection.get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      String priceString = doc['price'];
      double price = _convertPriceToDouble(priceString);
      totalPrice += price;
    }

    double formattedTotalPrice = totalPrice / 100;

    emit(ListItemLoaded(isListEmpty: false, totalPrice: formattedTotalPrice));
  }

  double _convertPriceToDouble(String priceString) {
    String numericString = priceString.replaceAll(RegExp(r'[^\d]'), '');
    return double.parse(numericString);
  }

  void excludeItem(String itemId) {
    CollectionReference listCollection =
        FirebaseFirestore.instance.collection('users');

    DocumentReference createdList = listCollection
        .doc(UserModel.idUserLogged)
        .collection('lists')
        .doc(listId)
        .collection('itens')
        .doc(itemId);

    createdList.delete();

    listCollection
        .doc(UserModel.idUserLogged)
        .collection('lists')
        .doc(listId)
        .update({
      'itens': FieldValue.arrayRemove([itemId]),
      'check': FieldValue.arrayRemove([itemId]),
    });
  }

  void checkItem(String itemId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(UserModel.idUserLogged)
        .collection('lists')
        .doc(listId)
        .collection('itens')
        .doc(itemId)
        .get()
        .then((doc) {
      if (doc.exists) {
        bool currentStatus = doc['status'] ?? false;
        bool newStatus = !currentStatus;

        FirebaseFirestore.instance
            .collection('users')
            .doc(UserModel.idUserLogged)
            .collection('lists')
            .doc(listId)
            .get()
            .then((doc) {
          List<dynamic> currentItens = doc['check'];

          if (currentItens.contains(itemId)) {
            currentItens.remove(itemId);
          } else {
            currentItens.add(itemId);
          }

          FirebaseFirestore.instance
              .collection('users')
              .doc(UserModel.idUserLogged)
              .collection('lists')
              .doc(listId)
              .update({'check': currentItens});
        });

        FirebaseFirestore.instance
            .collection('users')
            .doc(UserModel.idUserLogged)
            .collection('lists')
            .doc(listId)
            .collection('itens')
            .doc(itemId)
            .update({
          'status': newStatus,
        });
      }
    });
  }

  void createItem(String title) {
    String createdItemId;
    CollectionReference listCollection =
        FirebaseFirestore.instance.collection('users');

    DocumentReference createdList = listCollection
        .doc(UserModel.idUserLogged)
        .collection('lists')
        .doc(listId)
        .collection('itens')
        .doc();

    createdItemId = createdList.id;

    createdList.set({
      'title': title,
      'itemId': createdItemId,
      'hour': DateTime.now().toString(),
      'status': false,
      'qtd': 1,
      'price': 'R\$ 0,00',
    }).then((value) {
      listCollection
          .doc(UserModel.idUserLogged)
          .collection('lists')
          .doc(listId)
          .get()
          .then((doc) {
        List<dynamic> currentItens = doc['itens'];

        currentItens.add(createdItemId);

        listCollection
            .doc(UserModel.idUserLogged)
            .collection('lists')
            .doc(listId)
            .update({'itens': currentItens});
      });
    });
  }

  void addPrice(String price, String itemId, int qtd) {
    double priceValue = price.isEmpty
        ? 0.0
        : double.parse(price.replaceAll('R\$', '').replaceAll(',', '.').trim());
    double totalPrice = priceValue * qtd;

    FirebaseFirestore.instance
        .collection('users')
        .doc(UserModel.idUserLogged)
        .collection('lists')
        .doc(listId)
        .collection('itens')
        .doc(itemId)
        .update({
      'price': 'R\$ ${totalPrice.toStringAsFixed(2)}',
      'qtd': qtd,
    });
  }

  void checkListEmpty(String listId) {
    CollectionReference listsCollection =
        FirebaseFirestore.instance.collection('users');

    listsCollection
        .doc(UserModel.idUserLogged)
        .collection('lists')
        .doc(listId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        List<dynamic> lists = documentSnapshot['itens'];
        if (lists.isEmpty) {
          emit(ListItemLoaded(isListEmpty: true, totalPrice: totalPrice / 100));
        } else {
          emit(
              ListItemLoaded(isListEmpty: false, totalPrice: totalPrice / 100));
        }
      }
    });
  }
}
