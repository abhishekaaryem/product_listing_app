// lib/presentation/nav/nav_state.dart
import 'package:equatable/equatable.dart';

class NavState extends Equatable {
  final int selectedIndex;

  const NavState({this.selectedIndex = 0});

  NavState copyWith({int? selectedIndex}) {
    return NavState(selectedIndex: selectedIndex ?? this.selectedIndex);
  }

  @override
  List<Object?> get props => [selectedIndex];
}
