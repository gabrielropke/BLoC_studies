import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoaded extends LoginState {
  final bool obscureText;
  final bool loadingAccount;

  LoginLoaded({this.obscureText = true, this.loadingAccount = false});

  @override
  List<Object?> get props => [obscureText, loadingAccount];
}
