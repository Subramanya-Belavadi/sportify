part of 'venue_bloc.dart';

abstract class VenueEvent extends Equatable {
  const VenueEvent();
  @override
  List<Object?> get props => [];
}

class LoadVenues extends VenueEvent {
  const LoadVenues();
}

class FilterVenues extends VenueEvent {
  final String? sport;
  const FilterVenues(this.sport);
  @override
  List<Object?> get props => [sport];
}

class SearchVenues extends VenueEvent {
  final String query;
  const SearchVenues(this.query);
  @override
  List<Object?> get props => [query];
}
