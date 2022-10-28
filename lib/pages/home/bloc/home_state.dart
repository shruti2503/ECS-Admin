part of 'home_bloc.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState {
  final List<Student> students;
  final HomeStatus status;
  HomeState({
    this.students = const [],
    this.status = HomeStatus.initial,
  });

  HomeState copywith(
      {List<Student> Function()? students, HomeStatus Function()? status}) {
    return HomeState(
      students: students != null ? students() : this.students,
      status: status != null ? status() : this.status,
    );
  }
}
