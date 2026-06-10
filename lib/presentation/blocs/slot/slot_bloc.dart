import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/errors/failures.dart';
import '../../../domain/entities/slot_entity.dart';
import '../../../domain/repositories/slot_repository.dart';

part 'slot_event.dart';
part 'slot_state.dart';

class SlotBloc extends Bloc<SlotEvent, SlotState> {
  final SlotRepository _repository;

  SlotBloc(this._repository) : super(SlotInitial()) {
    on<LoadSlots>(_onLoadSlots);
    on<RefreshSlots>(_onRefreshSlots);
    on<SelectSlot>(_onSelectSlot);
    on<SelectDuration>(_onSelectDuration);
  }

  Future<void> _onLoadSlots(LoadSlots event, Emitter<SlotState> emit) async {
    emit(SlotLoading());
    try {
      final slots = await _repository.getSlots(event.venueId, event.date);
      emit(SlotLoaded(slots: slots));
    } on Failure catch (e) {
      emit(SlotError(e.message));
    } catch (_) {
      emit(const SlotError('Something went wrong. Please try again.'));
    }
  }

  Future<void> _onRefreshSlots(RefreshSlots event, Emitter<SlotState> emit) async {
    try {
      final slots = await _repository.getSlots(event.venueId, event.date);
      final prev = state is SlotLoaded ? (state as SlotLoaded).selectedSlot : null;
      emit(SlotLoaded(slots: slots, selectedSlot: prev));
    } on Failure catch (e) {
      emit(SlotError(e.message));
    } catch (_) {
      emit(const SlotError('Something went wrong. Please try again.'));
    }
  }

  void _onSelectSlot(SelectSlot event, Emitter<SlotState> emit) {
    if (state is SlotLoaded) {
      emit(SlotLoaded(
        slots: (state as SlotLoaded).slots,
        selectedSlot: event.slot,
        selectedDuration: 1,
      ));
    }
  }

  void _onSelectDuration(SelectDuration event, Emitter<SlotState> emit) {
    if (state is SlotLoaded) {
      final s = state as SlotLoaded;
      emit(SlotLoaded(
        slots: s.slots,
        selectedSlot: s.selectedSlot,
        selectedDuration: event.hours,
      ));
    }
  }
}
