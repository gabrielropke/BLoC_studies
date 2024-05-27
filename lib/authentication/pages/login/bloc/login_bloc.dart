import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_de_compras/authentication/pages/login/bloc/login_event.dart';
import 'package:lista_de_compras/authentication/pages/login/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  bool isVisible = true;
  LoginBloc() : super(LoginInitial()) {
    emit(LoginLoaded(obscureText: isVisible));

    on<LoginSetVisible>(
      (event, emit) {
        emit(LoginLoaded(obscureText: event.obscureText));
      },
    );

    on<LoginLoading>(
      (event, emit) {
        emit(LoginLoaded(loadingAccount: event.loadingAccount));
      },
    );
  }
}
