import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/errors/failures.dart';
import '../../../domain/entities/booking_entity.dart';
import '../../../domain/repositories/booking_repository.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository _repository;

  BookingBloc(this._repository) : super(BookingInitial()) {
    on<BookSlot>(_onBookSlot);
    on<LoadUserBookings>(_onLoadUserBookings);
    on<CancelBooking>(_onCancelBooking);
  }

  Future<void> _onBookSlot(BookSlot event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final booking = await _repository.bookSlot(
        slotId: event.slotId,
        userId: event.userId,
        durationHours: event.durationHours,
      );
      emit(BookingSuccess(booking));
    } on SlotAlreadyTakenFailure {
      emit(BookingSlotTaken());
    } on Failure catch (e) {
      emit(BookingError(e.message));
    } catch (_) {
      emit(const BookingError('Something went wrong. Please try again.'));
    }
  }

  Future<void> _onLoadUserBookings(LoadUserBookings event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final bookings = await _repository.getUserBookings(event.userId);
      emit(UserBookingsLoaded(bookings));
    } on Failure catch (e) {
      emit(BookingError(e.message));
    } catch (_) {
      emit(const BookingError('Something went wrong. Please try again.'));
    }
  }

  Future<void> _onCancelBooking(CancelBooking event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      await _repository.cancelBooking(event.bookingId);
      emit(BookingCancelled());
    } on Failure catch (e) {
      emit(BookingError(e.message));
    } catch (_) {
      emit(const BookingError('Something went wrong. Please try again.'));
    }
  }
}
