import 'package:equatable/equatable.dart';

class ListItemEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddItem extends ListItemEvent {
  final String name;

  AddItem(this.name);

  @override
  List<Object> get props => [name];
}

class ExcludeItem extends ListItemEvent {
  final String itemId;

  ExcludeItem(this.itemId);

  @override
  List<Object> get props => [itemId];
}

class UpdateItem extends ListItemEvent {
  final String name;
  final String itemId;

  UpdateItem(this.name, this.itemId);

  @override
  List<Object> get props => [name, itemId];
}

class CheckItem extends ListItemEvent {
  final String itemId;

  CheckItem(this.itemId);

  @override
  List<Object> get props => [itemId];
}

class AddPrice extends ListItemEvent {
  final String price;
  final String itemId;
  final int qtd;

  AddPrice(this.price, this.itemId, this.qtd);

  @override
  List<Object> get props => [price, itemId, qtd];
}

class CalculateTotalPrice extends ListItemEvent {}
