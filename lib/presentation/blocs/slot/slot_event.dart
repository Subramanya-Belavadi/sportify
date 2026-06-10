part of 'slot_bloc.dart';

abstract class SlotEvent extends Equatable {
  const SlotEvent();
  @override
  List<Object?> get props => [];
}

class LoadSlots extends SlotEvent {
  final String venueId;
  final String date;
  const LoadSlots({required this.venueId, required this.date});
  @override
  List<Object?> get props => [venueId, date];
}

class RefreshSlots extends SlotEvent {
  final String venueId;
  final String date;
  const RefreshSlots({required this.venueId, required this.date});
  @override
  List<Object?> get props => [venueId, date];
}

class SelectSlot extends SlotEvent {
  final SlotEntity slot;
  const SelectSlot(this.slot);
  @override
  List<Object?> get props => [slot];
}

class SelectDuration extends SlotEvent {
  final int hours;
  const SelectDuration(this.hours);
  @override
  List<Object?> get props => [hours];
}
