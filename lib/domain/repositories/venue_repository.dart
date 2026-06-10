import '../entities/venue_entity.dart';

abstract class VenueRepository {
  Future<List<VenueEntity>> getVenues();
  Future<VenueEntity> getVenueById(String id);
}
