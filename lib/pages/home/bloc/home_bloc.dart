import 'package:bloc/bloc.dart';
import 'package:lista_de_compras/pages/home/bloc/home_event.dart';
import 'package:lista_de_compras/pages/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    // ignore: invalid_use_of_visible_for_testing_member
    emit(HomeLoaded(index: 0));

    on<HomeNewIndex>((event, emit) => emit(HomeLoaded(index: event.newIndex)));
  }
}
