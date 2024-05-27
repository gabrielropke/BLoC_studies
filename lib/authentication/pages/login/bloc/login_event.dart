

import 'package:equatable/equatable.dart';

class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginSetVisible extends LoginEvent {

  final bool obscureText;

  LoginSetVisible(this.obscureText);

  @override
  List<Object?> get props => [obscureText];

}

class LoginLoading extends LoginEvent {

  final bool loadingAccount;

  LoginLoading(this.loadingAccount);

  @override
  List<Object?> get props => [loadingAccount];

}