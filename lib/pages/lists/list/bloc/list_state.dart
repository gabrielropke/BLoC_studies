import 'package:equatable/equatable.dart';

class ListState extends Equatable {
  @override
  List<Object> get props => [];
}

class ListInitial extends ListState {}

class ListLoaded extends ListState {
  final bool isListEmpty;

  ListLoaded({required this.isListEmpty});

  @override
  List<Object> get props => [isListEmpty];
}
