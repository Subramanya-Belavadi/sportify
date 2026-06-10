part of 'venue_bloc.dart';

abstract class VenueEvent extends Equatable {
  const VenueEvent();
  @override
  List<Object?> get props => [];
}

class LoadVenues extends VenueEvent {
  const LoadVenues();
}
