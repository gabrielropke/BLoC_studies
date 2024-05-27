import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_de_compras/authentication/pages/register/bloc/register_event.dart';
import 'package:lista_de_compras/authentication/pages/register/bloc/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  bool isVisible = true;
  RegisterBloc() : super(RegisterInitial()) {
    emit(RegisterLoaded(obscureText: isVisible));

    on<RegisterSetVisible>(
      (event, emit) {
        emit(RegisterLoaded(obscureText: event.obscureText));
      },
    );

    on<RegisterLoading>(
      (event, emit) {
        emit(RegisterLoaded(loadingAccount: event.loadingAccount));
      },
    );
  }
}
