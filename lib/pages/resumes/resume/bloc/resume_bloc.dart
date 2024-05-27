
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_de_compras/pages/resumes/resume/bloc/resume_event.dart';
import 'package:lista_de_compras/pages/resumes/resume/bloc/resume_state.dart';
import 'package:lista_de_compras/utils/model/user_model.dart';

class ResumeBloc extends Bloc<ResumeEvent, ResumeState> {
  ResumeBloc() : super(ResumeInitial()) {

    checkListEmpty();

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
        emit(ResumeLoaded(isListEmpty: true));
      } else {
        emit(ResumeLoaded(isListEmpty: false));
      }
    });
  }
}