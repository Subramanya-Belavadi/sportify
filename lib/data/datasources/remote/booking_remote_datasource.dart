import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../models/booking_model.dart';

abstract class BookingRemoteDatasource {
  Future<BookingModel> bookSlot({required String slotId, required String userId, int durationHours = 1});
  Future<List<BookingModel>> getUserBookings(String userId);
  Future<void> cancelBooking(String bookingId);
}

class BookingRemoteDatasourceImpl implements BookingRemoteDatasource {
  final ApiClient _client;
  BookingRemoteDatasourceImpl(this._client);

  @override
  Future<BookingModel> bookSlot({required String slotId, required String userId, int durationHours = 1}) async {
    final res = await _client.post(
      ApiEndpoints.bookings,
      data: {'slot_id': slotId, 'user_id': userId, 'duration_hours': durationHours},
    );
    return BookingModel.fromJson(res.data);
  }

  @override
  Future<List<BookingModel>> getUserBookings(String userId) async {
    final res = await _client.get(ApiEndpoints.userBookings(userId));
    return (res.data as List).map((e) => BookingModel.fromJson(e)).toList();
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await _client.delete(ApiEndpoints.bookingById(bookingId));
  }
}
