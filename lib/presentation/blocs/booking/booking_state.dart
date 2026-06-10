part of 'booking_bloc.dart';

abstract class BookingState extends Equatable {
  const BookingState();
  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}
class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final BookingEntity booking;
  const BookingSuccess(this.booking);
  @override
  List<Object?> get props => [booking];
}

class BookingSlotTaken extends BookingState {
  final String message;
  const BookingSlotTaken(this.message);
  @override
  List<Object?> get props => [message];
}

class BookingError extends BookingState {
  final String message;
  const BookingError(this.message);
  @override
  List<Object?> get props => [message];
}

class UserBookingsLoaded extends BookingState {
  final List<BookingEntity> bookings;
  const UserBookingsLoaded(this.bookings);
  @override
  List<Object?> get props => [bookings];
}

class BookingCancelled extends BookingState {}
