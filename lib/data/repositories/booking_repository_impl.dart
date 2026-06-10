import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  // TODO: inject BookingRemoteDatasource
  @override
  Future<BookingEntity> bookSlot({required String slotId, required String userId}) =>
      throw UnimplementedError();

  @override
  Future<List<BookingEntity>> getUserBookings(String userId) => throw UnimplementedError();

  @override
  Future<void> cancelBooking(String bookingId) => throw UnimplementedError();
}
