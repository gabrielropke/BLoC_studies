import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoaded extends RegisterState {
  final bool obscureText;
  final bool loadingAccount;

  RegisterLoaded({this.obscureText = true, this.loadingAccount = false});

  @override
  List<Object?> get props => [obscureText, loadingAccount];
}
