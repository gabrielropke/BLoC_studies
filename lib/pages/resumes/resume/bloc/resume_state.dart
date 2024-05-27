import 'package:equatable/equatable.dart';

class ResumeState extends Equatable {
  @override
  List<Object> get props => [];
}

class ResumeInitial extends ResumeState {}

class ResumeLoaded extends ResumeState {
  final bool isListEmpty;

  ResumeLoaded({required this.isListEmpty});

  @override
  List<Object> get props => [isListEmpty];
}
