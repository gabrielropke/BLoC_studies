import 'package:equatable/equatable.dart';

class ListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddNewList extends ListEvent {
  final String newItemList;

  AddNewList({required this.newItemList});

  @override
  List<Object> get props => [newItemList];
}

class DeleteList extends ListEvent {
  final String listID;

  DeleteList(this.listID);

  @override
  List<Object> get props => [listID];
}

class UpdateList extends ListEvent {
  final String listID;
  final String newTitle;

  UpdateList(this.listID, this.newTitle);

  @override
  List<Object> get props => [listID, newTitle];
}
