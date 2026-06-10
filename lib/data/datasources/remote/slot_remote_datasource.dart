import '../../../data/models/slot_model.dart';

abstract class SlotRemoteDatasource {
  Future<List<SlotModel>> getSlots(String venueId, String date);
}

class SlotRemoteDatasourceImpl implements SlotRemoteDatasource {
  // TODO: inject ApiClient
  @override
  Future<List<SlotModel>> getSlots(String venueId, String date) => throw UnimplementedError();
}
