// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_de_compras/pages/lists/list/bloc/list_event.dart';
import 'package:lista_de_compras/pages/lists/list/bloc/list_state.dart';
import 'package:lista_de_compras/utils/model/user_model.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(ListInitial()) {
    checkListEmpty();

    on<AddNewList>(
      (event, emit) {
        createList(event.newItemList);
      },
    );

    on<DeleteList>(
      (event, emit) {
        deleteList(event.listID);
      },
    );

    on<UpdateList>(
      (event, emit) {
        upadteList(event.listID, event.newTitle);
      },
    );
  }

  void checkListEmpty() {
    CollectionReference novidadesCollection =
        FirebaseFirestore.instance.collection('users');

    novidadesCollection
        .doc(UserModel.idUserLogged)
        .collection('lists')
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        emit(ListLoaded(isListEmpty: true));
      } else {
        emit(ListLoaded(isListEmpty: false));
      }
    });
  }

  void createList(String title) {
    String createdListId;
    CollectionReference listCollection =
        FirebaseFirestore.instance.collection('users');

    DocumentReference createdList =
        listCollection.doc(UserModel.idUserLogged).collection('lists').doc();

    createdListId = createdList.id;

    createdList.set({
      'title': title,
      'listId': createdListId,
      'hour': DateTime.now().toString(),
      'itens': [],
      'check': [],
      'status': false,
    }).then((value) {
      listCollection.doc(UserModel.idUserLogged).get().then((doc) {
        List<dynamic> currentLists = doc['lists'];

        currentLists.add(createdListId);

        listCollection
            .doc(UserModel.idUserLogged)
            .update({'lists': currentLists});
      });
    });
  }

  void upadteList(String listID, String title) {
    CollectionReference listCollection =
        FirebaseFirestore.instance.collection('users');

    DocumentReference createdList = listCollection
        .doc(UserModel.idUserLogged)
        .collection('lists')
        .doc(listID);

    createdList.update({'title': title});
  }

  void deleteList(String listID) {
    CollectionReference listCollection =
        FirebaseFirestore.instance.collection('users');

    DocumentReference createdList = listCollection
        .doc(UserModel.idUserLogged)
        .collection('lists')
        .doc(listID);

    createdList.delete().then((value) {
      listCollection
      .doc(UserModel.idUserLogged)
      .update({
        'lists': FieldValue.arrayRemove([listID])
      });
    });
  }
}
