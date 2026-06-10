import '../entities/slot_entity.dart';

abstract class SlotRepository {
  Future<List<SlotEntity>> getSlots(String venueId, String date);
}
