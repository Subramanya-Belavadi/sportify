part of 'venue_bloc.dart';

abstract class VenueState extends Equatable {
  const VenueState();
  @override
  List<Object?> get props => [];
}

class VenueInitial extends VenueState {}
class VenueLoading extends VenueState {}

class VenueLoaded extends VenueState {
  final List<VenueEntity> allVenues;
  final String? selectedSport;
  final String searchQuery;

  const VenueLoaded(this.allVenues, {this.selectedSport, this.searchQuery = ''});

  List<VenueEntity> get venues {
    var list = selectedSport == null
        ? allVenues
        : allVenues.where((v) => v.sport == selectedSport).toList();
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list.where((v) =>
        v.name.toLowerCase().contains(q) ||
        v.sport.toLowerCase().contains(q) ||
        v.address.toLowerCase().contains(q),
      ).toList();
    }
    return list;
  }

  List<String> get sports {
    final seen = <String>{};
    return allVenues.map((v) => v.sport).where(seen.add).toList();
  }

  @override
  List<Object?> get props => [allVenues, selectedSport, searchQuery];
}

class VenueError extends VenueState {
  final String message;
  const VenueError(this.message);
  @override
  List<Object?> get props => [message];
}
