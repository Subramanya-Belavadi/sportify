import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/venue_entity.dart';
import '../../blocs/slot/slot_bloc.dart';
import '../../router/app_router.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import 'widgets/slot_grid.dart';

class VenueDetailPage extends StatefulWidget {
  final String venueId;
  final VenueEntity venue;
  const VenueDetailPage({super.key, required this.venueId, required this.venue});

  @override
  State<VenueDetailPage> createState() => _VenueDetailPageState();
}

class _VenueDetailPageState extends State<VenueDetailPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SlotBloc>()
        ..add(LoadSlots(
          venueId: widget.venueId,
          date: DateFormatter.toApiFormat(_selectedDate),
        )),
      child: Scaffold(
        appBar: AppBar(title: Text(widget.venue.name)),
        body: Column(
          children: [
            _VenueInfoBar(venue: widget.venue),
            _DateBar(
              selectedDate: _selectedDate,
              onDateChanged: (date) {
                setState(() => _selectedDate = date);
              },
            ),
            Expanded(
              child: BlocBuilder<SlotBloc, SlotState>(
                builder: (context, state) {
                  if (state is SlotLoading) return const LoadingWidget();
                  if (state is SlotError) {
                    return AppErrorWidget(
                      message: state.message,
                      onRetry: () => context.read<SlotBloc>().add(
                            LoadSlots(
                              venueId: widget.venueId,
                              date: DateFormatter.toApiFormat(_selectedDate),
                            ),
                          ),
                    );
                  }
                  if (state is SlotLoaded) {
                    if (state.slots.isEmpty) {
                      return const EmptyStateWidget(
                        message: AppStrings.noSlotsFound,
                        icon: Icons.access_time_outlined,
                      );
                    }
                    return SlotGrid(
                      slots: state.slots,
                      selectedSlot: state.selectedSlot,
                      onSlotTap: (slot) =>
                          context.read<SlotBloc>().add(SelectSlot(slot)),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BlocBuilder<SlotBloc, SlotState>(
          builder: (context, state) {
            final selected =
                state is SlotLoaded ? state.selectedSlot : null;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: ElevatedButton(
                  onPressed: selected != null
                      ? () => context.push(
                            AppRouter.bookingConfirm,
                            extra: {
                              'venue': widget.venue,
                              'slot': selected,
                            },
                          )
                      : null,
                  child: const Text(AppStrings.bookSlot),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _VenueInfoBar extends StatelessWidget {
  final VenueEntity venue;
  const _VenueInfoBar({required this.venue});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined,
              size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Expanded(
            child: Text(venue.address,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
          ),
          Text(
            '₹${venue.pricePerHour.toStringAsFixed(0)}/hr',
            style: const TextStyle(
                color: AppColors.primary, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _DateBar extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;
  const _DateBar({required this.selectedDate, required this.onDateChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primarySurface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_outlined,
              size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            DateFormatter.toDisplayFormat(selectedDate),
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: AppColors.primary),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30)),
                builder: (context, child) => Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                        primary: AppColors.primary),
                  ),
                  child: child!,
                ),
              );
              if (picked != null) {
                onDateChanged(picked);
                if (context.mounted) {
                  context.read<SlotBloc>().add(LoadSlots(
                        venueId: (context
                                .findAncestorStateOfType<_VenueDetailPageState>()!)
                            .widget
                            .venueId,
                        date: DateFormatter.toApiFormat(picked),
                      ));
                }
              }
            },
            child: const Text(
              AppStrings.selectDate,
              style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
