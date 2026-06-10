import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../models/venue_model.dart';

abstract class VenueRemoteDatasource {
  Future<List<VenueModel>> getVenues();
  Future<VenueModel> getVenueById(String id);
}

class VenueRemoteDatasourceImpl implements VenueRemoteDatasource {
  final ApiClient _client;
  VenueRemoteDatasourceImpl(this._client);

  @override
  Future<List<VenueModel>> getVenues() async {
    final res = await _client.get(ApiEndpoints.venues);
    return (res.data as List).map((e) => VenueModel.fromJson(e)).toList();
  }

  @override
  Future<VenueModel> getVenueById(String id) async {
    final res = await _client.get('/venues/$id');
    return VenueModel.fromJson(res.data);
  }
}
