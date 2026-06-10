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
    // TODO: implement
    throw UnimplementedError();
  }

  Future<void> _onLoadUserBookings(LoadUserBookings event, Emitter<BookingState> emit) async {
    // TODO: implement
    throw UnimplementedError();
  }

  Future<void> _onCancelBooking(CancelBooking event, Emitter<BookingState> emit) async {
    // TODO: implement
    throw UnimplementedError();
  }
}
