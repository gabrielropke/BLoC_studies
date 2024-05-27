import 'package:equatable/equatable.dart';

class RegisterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterSetVisible extends RegisterEvent {
  final bool obscureText;

  RegisterSetVisible(this.obscureText);

  @override
  List<Object?> get props => [obscureText];
}

class RegisterLoading extends RegisterEvent {
  final bool loadingAccount;

  RegisterLoading(this.loadingAccount);

  @override
  List<Object?> get props => [loadingAccount];
}
