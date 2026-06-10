import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../models/slot_model.dart';

abstract class SlotRemoteDatasource {
  Future<List<SlotModel>> getSlots(String venueId, String date);
}

class SlotRemoteDatasourceImpl implements SlotRemoteDatasource {
  final ApiClient _client;
  SlotRemoteDatasourceImpl(this._client);

  @override
  Future<List<SlotModel>> getSlots(String venueId, String date) async {
    final res = await _client.get(ApiEndpoints.venueSlots(venueId, date));
    return (res.data as List).map((e) => SlotModel.fromJson(e)).toList();
  }
}
