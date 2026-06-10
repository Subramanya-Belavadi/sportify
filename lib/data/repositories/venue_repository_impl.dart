import '../../domain/entities/venue_entity.dart';
import '../../domain/repositories/venue_repository.dart';

class VenueRepositoryImpl implements VenueRepository {
  // TODO: inject VenueRemoteDatasource
  @override
  Future<List<VenueEntity>> getVenues() => throw UnimplementedError();

  @override
  Future<VenueEntity> getVenueById(String id) => throw UnimplementedError();
}
