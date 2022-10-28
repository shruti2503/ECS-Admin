part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class LoadStudentsEvent extends HomeEvent {
  LoadStudentsEvent();
}
