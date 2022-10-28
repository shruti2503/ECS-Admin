import 'package:bloc/bloc.dart';
import 'package:ecsadmin/database/database.dart';
import 'package:ecsadmin/models/student.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required MongoDatabase database})
      : _database = database,
        super(HomeState()) {
    on<LoadStudentsEvent>(_loadEvents);
  }

  final MongoDatabase _database;

  Future<void> _loadEvents(
      LoadStudentsEvent event, Emitter<HomeState> emit) async {
    emit(state.copywith(
      status: () => HomeStatus.loading,
    ));
    await emit.forEach<List<Student>> (
      _database.getAllStudentsResponse(),
      onData: (data) => state.copywith(
        students: () => data,
        status: () => HomeStatus.loaded,
      ),
    );
  }
}
