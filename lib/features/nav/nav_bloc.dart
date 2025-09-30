// lib/presentation/nav/nav_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'nav_event.dart';
import 'nav_state.dart';

class NavBloc extends Bloc<NavEvent, NavState> {
  NavBloc() : super(const NavState()) {
    on<NavItemSelected>((event, emit) {
      emit(state.copyWith(selectedIndex: event.index));
    });
  }
}
