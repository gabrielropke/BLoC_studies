import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_de_compras/pages/resumes/receipt/bloc/receipt_bloc.dart';
import 'package:lista_de_compras/pages/resumes/receipt/bloc/receipt_state.dart';
import 'package:lista_de_compras/pages/resumes/receipt/widgets/receipt_widget.dart';
import 'package:lista_de_compras/utils/loading.dart';

class ReceiptPage extends StatefulWidget {
  const ReceiptPage({super.key});

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  late ReceiptBloc receiptBloc;
  late String listId;
  late String title;
  late String hour;
  late List<dynamic> itens;
  late List<dynamic> check;
  late double totalPrice;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    title = args['title'] ?? '';
    listId = args['listId'] ?? '';
    hour = args['hour'] ?? '';
    itens = args['itens'] ?? '';
    check = args['check'] ?? '';
    totalPrice = args['totalPrice'] ?? '';
    receiptBloc = ReceiptBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => receiptBloc,
        child: BlocBuilder<ReceiptBloc, ReceiptState>(
          builder: (context, state) {
            if (state is ReceiptInitial) {
              return LoadingWidget.progressIndication();
            }

            if (state is ReceiptLoaded) {
              return ReceiptWidget(
                  receiptBloc: receiptBloc,
                  listId: listId,
                  title: title,
                  hour: hour,
                  itens: itens,
                  check: check,
                  totalPrice: totalPrice,);
            }

            return LoadingWidget.progressIndication();
          },
        ),
      ),
    );
  }
}
