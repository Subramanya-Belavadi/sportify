part of 'slot_bloc.dart';

abstract class SlotState extends Equatable {
  const SlotState();
  @override
  List<Object?> get props => [];
}

class SlotInitial extends SlotState {}
class SlotLoading extends SlotState {}

class SlotLoaded extends SlotState {
  final List<SlotEntity> slots;
  final SlotEntity? selectedSlot;
  const SlotLoaded({required this.slots, this.selectedSlot});
  @override
  List<Object?> get props => [slots, selectedSlot];
}

class SlotError extends SlotState {
  final String message;
  const SlotError(this.message);
  @override
  List<Object?> get props => [message];
}
