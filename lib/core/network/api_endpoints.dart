class ApiEndpoints {
  ApiEndpoints._();

  static const String venues = '/venues';
  static String venueSlots(String id, String date) => '/venues/$id/slots?date=$date';
  static const String bookings = '/bookings';
  static String userBookings(String userId) => '/users/$userId/bookings';
  static String bookingById(String id) => '/bookings/$id';
  static String reserveSlot(String venueId, String slotId) =>
      '/venues/$venueId/slots/$slotId/reserve';
}
