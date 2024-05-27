import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}


class HomeInitial extends HomeState {}

class HomeLoaded extends HomeState {
  final int index;

  HomeLoaded({required this.index});

  @override
  List<Object> get props => [index];
}
