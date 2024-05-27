import 'package:equatable/equatable.dart';

class ListItemState extends Equatable {
  @override
  List<Object> get props => [];
}

class ListItemInitial extends ListItemState {}

class ListItemLoaded extends ListItemState {
  final bool isListEmpty;
  final double totalPrice;

  ListItemLoaded({required this.isListEmpty, required this.totalPrice});
  

  @override
  List<Object> get props => [isListEmpty, totalPrice];
}
