import '../../../data/models/venue_model.dart';

abstract class VenueRemoteDatasource {
  Future<List<VenueModel>> getVenues();
  Future<VenueModel> getVenueById(String id);
}

class VenueRemoteDatasourceImpl implements VenueRemoteDatasource {
  // TODO: inject ApiClient
  @override
  Future<List<VenueModel>> getVenues() => throw UnimplementedError();

  @override
  Future<VenueModel> getVenueById(String id) => throw UnimplementedError();
}
