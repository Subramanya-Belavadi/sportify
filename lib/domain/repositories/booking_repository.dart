import '../entities/booking_entity.dart';

abstract class BookingRepository {
  Future<BookingEntity> bookSlot({required String slotId, required String userId, int durationHours = 1});
  Future<List<BookingEntity>> getUserBookings(String userId);
  Future<void> cancelBooking(String bookingId);
}
