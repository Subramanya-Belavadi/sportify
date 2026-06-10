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
  }

  Future<void> _onLoadSlots(LoadSlots event, Emitter<SlotState> emit) async {
    // TODO: implement
    throw UnimplementedError();
  }

  Future<void> _onRefreshSlots(RefreshSlots event, Emitter<SlotState> emit) async {
    // TODO: implement
    throw UnimplementedError();
  }

  void _onSelectSlot(SelectSlot event, Emitter<SlotState> emit) {
    // TODO: implement
    throw UnimplementedError();
  }
}
