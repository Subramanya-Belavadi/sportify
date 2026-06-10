import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/errors/failures.dart';
import '../../../domain/entities/venue_entity.dart';
import '../../../domain/repositories/venue_repository.dart';

part 'venue_event.dart';
part 'venue_state.dart';

class VenueBloc extends Bloc<VenueEvent, VenueState> {
  final VenueRepository _repository;

  VenueBloc(this._repository) : super(VenueInitial()) {
    on<LoadVenues>(_onLoadVenues);
  }

  Future<void> _onLoadVenues(LoadVenues event, Emitter<VenueState> emit) async {
    emit(VenueLoading());
    try {
      final venues = await _repository.getVenues();
      emit(VenueLoaded(venues));
    } on Failure catch (e) {
      emit(VenueError(e.message));
    }
  }
}
