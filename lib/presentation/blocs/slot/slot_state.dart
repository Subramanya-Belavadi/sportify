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
  final int selectedDuration;

  const SlotLoaded({
    required this.slots,
    this.selectedSlot,
    this.selectedDuration = 1,
  });

  int get maxDuration {
    if (selectedSlot == null) return 1;
    int count = 0;
    final idx = slots.indexWhere((s) => s.id == selectedSlot!.id);
    for (int i = idx; i < slots.length && i < idx + 4; i++) {
      if (slots[i].isAvailable) {
        count++;
      } else {
        break;
      }
    }
    return count.clamp(1, 4);
  }

  List<SlotEntity> get selectedSlots {
    if (selectedSlot == null) return [];
    final idx = slots.indexWhere((s) => s.id == selectedSlot!.id);
    if (idx == -1) return [];
    return slots.sublist(idx, (idx + selectedDuration).clamp(0, slots.length));
  }

  @override
  List<Object?> get props => [slots, selectedSlot, selectedDuration];
}

class SlotError extends SlotState {
  final String message;
  const SlotError(this.message);
  @override
  List<Object?> get props => [message];
}
