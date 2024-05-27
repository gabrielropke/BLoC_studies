import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_de_compras/pages/resumes/receipt/bloc/receipt_event.dart';
import 'package:lista_de_compras/pages/resumes/receipt/bloc/receipt_state.dart';

class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  ReceiptBloc() : super(ReceiptInitial()) {
    emit(ReceiptLoaded());
  }
}
