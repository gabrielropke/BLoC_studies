import 'package:equatable/equatable.dart';

class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeNewIndex extends HomeEvent {
  final int newIndex;

  HomeNewIndex({required this.newIndex});

  @override
  List<Object> get props => [newIndex];
}
