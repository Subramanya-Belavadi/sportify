part of 'booking_bloc.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();
  @override
  List<Object?> get props => [];
}

class BookSlot extends BookingEvent {
  final String slotId;
  final String userId;
  const BookSlot({required this.slotId, required this.userId});
  @override
  List<Object?> get props => [slotId, userId];
}

class LoadUserBookings extends BookingEvent {
  final String userId;
  const LoadUserBookings(this.userId);
  @override
  List<Object?> get props => [userId];
}

class CancelBooking extends BookingEvent {
  final String bookingId;
  final String userId;
  const CancelBooking({required this.bookingId, required this.userId});
  @override
  List<Object?> get props => [bookingId, userId];
}
