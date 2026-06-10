import '../entities/booking_entity.dart';

abstract class BookingRepository {
  Future<BookingEntity> bookSlot({required String slotId, required String userId});
  Future<List<BookingEntity>> getUserBookings(String userId);
  Future<void> cancelBooking(String bookingId);
}
