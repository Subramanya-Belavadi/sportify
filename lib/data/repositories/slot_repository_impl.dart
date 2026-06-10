import '../../domain/entities/slot_entity.dart';
import '../../domain/repositories/slot_repository.dart';

class SlotRepositoryImpl implements SlotRepository {
  // TODO: inject SlotRemoteDatasource
  @override
  Future<List<SlotEntity>> getSlots(String venueId, String date) => throw UnimplementedError();
}
