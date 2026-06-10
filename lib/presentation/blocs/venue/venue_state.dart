part of 'venue_bloc.dart';

abstract class VenueState extends Equatable {
  const VenueState();
  @override
  List<Object?> get props => [];
}

class VenueInitial extends VenueState {}
class VenueLoading extends VenueState {}

class VenueLoaded extends VenueState {
  final List<VenueEntity> venues;
  const VenueLoaded(this.venues);
  @override
  List<Object?> get props => [venues];
}

class VenueError extends VenueState {
  final String message;
  const VenueError(this.message);
  @override
  List<Object?> get props => [message];
}
