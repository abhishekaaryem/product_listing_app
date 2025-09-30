import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class SplashEvent {}

class StartSplash extends SplashEvent {}

// States
abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashComplete extends SplashState {}

// Bloc
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<StartSplash>((event, emit) async {
      await Future.delayed(const Duration(seconds: 3));
      emit(SplashComplete());
    });
  }
}
