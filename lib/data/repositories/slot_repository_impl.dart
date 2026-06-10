import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/slot_entity.dart';
import '../../domain/repositories/slot_repository.dart';
import '../datasources/remote/slot_remote_datasource.dart';

class SlotRepositoryImpl implements SlotRepository {
  final SlotRemoteDatasource _datasource;
  SlotRepositoryImpl(this._datasource);

  @override
  Future<List<SlotEntity>> getSlots(String venueId, String date) async {
    try {
      return await _datasource.getSlots(venueId, date);
    } on NetworkException {
      throw const NetworkFailure();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    }
  }
}
