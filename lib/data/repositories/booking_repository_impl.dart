import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/remote/booking_remote_datasource.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDatasource _datasource;
  BookingRepositoryImpl(this._datasource);

  @override
  Future<BookingEntity> bookSlot({required String slotId, required String userId}) async {
    try {
      return await _datasource.bookSlot(slotId: slotId, userId: userId);
    } on SlotAlreadyTakenException {
      throw const SlotAlreadyTakenFailure();
    } on NetworkException {
      throw const NetworkFailure();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    }
  }

  @override
  Future<List<BookingEntity>> getUserBookings(String userId) async {
    try {
      return await _datasource.getUserBookings(userId);
    } on NetworkException {
      throw const NetworkFailure();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    }
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    try {
      await _datasource.cancelBooking(bookingId);
    } on NetworkException {
      throw const NetworkFailure();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    }
  }
}
