import '../../../data/models/booking_model.dart';

abstract class BookingRemoteDatasource {
  Future<BookingModel> bookSlot({required String slotId, required String userId});
  Future<List<BookingModel>> getUserBookings(String userId);
  Future<void> cancelBooking(String bookingId);
}

class BookingRemoteDatasourceImpl implements BookingRemoteDatasource {
  // TODO: inject ApiClient
  @override
  Future<BookingModel> bookSlot({required String slotId, required String userId}) =>
      throw UnimplementedError();

  @override
  Future<List<BookingModel>> getUserBookings(String userId) => throw UnimplementedError();

  @override
  Future<void> cancelBooking(String bookingId) => throw UnimplementedError();
}
