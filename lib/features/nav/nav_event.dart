// lib/presentation/nav/nav_event.dart
import 'package:equatable/equatable.dart';

abstract class NavEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NavItemSelected extends NavEvent {
  final int index;
  NavItemSelected(this.index);

  @override
  List<Object?> get props => [index];
}
