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
    on<FilterVenues>(_onFilterVenues);
    on<SearchVenues>(_onSearchVenues);
  }

  Future<void> _onLoadVenues(LoadVenues event, Emitter<VenueState> emit) async {
    emit(VenueLoading());
    try {
      final venues = await _repository.getVenues();
      emit(VenueLoaded(venues));
    } on Failure catch (e) {
      emit(VenueError(e.message));
    } catch (_) {
      emit(const VenueError('Something went wrong. Please try again.'));
    }
  }

  void _onFilterVenues(FilterVenues event, Emitter<VenueState> emit) {
    if (state is VenueLoaded) {
      final current = state as VenueLoaded;
      final newSport = current.selectedSport == event.sport ? null : event.sport;
      emit(VenueLoaded(current.allVenues, selectedSport: newSport, searchQuery: current.searchQuery));
    }
  }

  void _onSearchVenues(SearchVenues event, Emitter<VenueState> emit) {
    if (state is VenueLoaded) {
      final current = state as VenueLoaded;
      emit(VenueLoaded(current.allVenues, selectedSport: current.selectedSport, searchQuery: event.query));
    }
  }
}
