import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/venue_entity.dart';
import '../../../domain/repositories/booking_repository.dart';
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
  Set<int> _userBlockedHours = {};

  @override
  void initState() {
    super.initState();
    _loadUserBlockedHours(_selectedDate);
  }

  Future<void> _loadUserBlockedHours(DateTime date) async {
    try {
      final userId = sl<ApiClient>().currentUserId ?? '';
      if (userId.isEmpty) return;
      final bookings = await sl<BookingRepository>().getUserBookings(userId);
      final dateStr = DateFormatter.toApiFormat(date);
      final Set<int> hours = {};
      for (final b in bookings) {
        if (b.date == dateStr && b.status == 'confirmed') {
          final startHour = int.parse(b.startTime.split(':')[0]);
          final endHour = int.parse(b.endTime.split(':')[0]);
          for (int h = startHour; h < endHour; h++) {
            hours.add(h);
          }
        }
      }
      if (mounted) setState(() => _userBlockedHours = hours);
    } catch (_) {}
  }

  int _effectiveMaxDuration(SlotLoaded state) {
    if (state.selectedSlot == null) return 1;
    final idx = state.slots.indexWhere((s) => s.id == state.selectedSlot!.id);
    int count = 0;
    for (int i = idx; i < state.slots.length && i < idx + 4; i++) {
      final slot = state.slots[i];
      final hour = int.parse(slot.startTime.split(':')[0]);
      if (!slot.isAvailable || _userBlockedHours.contains(hour)) break;
      count++;
    }
    return count.clamp(1, 4);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SlotBloc>()
        ..add(LoadSlots(
          venueId: widget.venueId,
          date: DateFormatter.toApiFormat(_selectedDate),
        )),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        body: Column(
          children: [
            _VenueHeroHeader(venue: widget.venue),
            _DateBar(
              selectedDate: _selectedDate,
              onDateChanged: (date) {
                setState(() {
                  _selectedDate = date;
                  _userBlockedHours = {};
                });
                _loadUserBlockedHours(date);
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
                      selectedSlots: state.selectedSlots,
                      userBlockedHours: _userBlockedHours,
                      onSlotTap: (slot) {
                        final hour = int.parse(slot.startTime.split(':')[0]);
                        if (!_userBlockedHours.contains(hour)) {
                          context.read<SlotBloc>().add(SelectSlot(slot));
                        }
                      },
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
            if (state is! SlotLoaded || state.selectedSlot == null) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, -4))],
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      child: const Text('Select a Time Slot', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
              );
            }
            final s = state;
            final selected = s.selectedSlot!;
            final endSlots = s.selectedSlots;
            final endTime = endSlots.isNotEmpty ? endSlots.last.endTime : selected.endTime;
            final price = widget.venue.pricePerHour * s.selectedDuration;

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, -4))],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Duration selector
                      Row(
                        children: [
                          const Text('Duration:', style: TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                          const SizedBox(width: 10),
                          ...List.generate(_effectiveMaxDuration(s), (i) {
                            final h = i + 1;
                            final active = h == s.selectedDuration;
                            return GestureDetector(
                              onTap: () => context.read<SlotBloc>().add(SelectDuration(h)),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: active ? AppColors.primary : AppColors.primarySurface,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: active ? AppColors.primary : AppColors.divider),
                                ),
                                child: Text('${h}h', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: active ? Colors.white : AppColors.primary)),
                              ),
                            );
                          }),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('₹${price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
                              Text('+ 18% GST', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => context.push(
                          AppRouter.bookingConfirm,
                          extra: {'venue': widget.venue, 'slot': selected, 'duration': s.selectedDuration, 'endTime': endTime},
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(50),
                          elevation: 3,
                          shadowColor: AppColors.primary.withValues(alpha: 0.4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(
                          '${DateFormatter.toTimeDisplay(selected.startTime)} – ${DateFormatter.toTimeDisplay(endTime)}  ·  Book',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _VenueHeroHeader extends StatelessWidget {
  final VenueEntity venue;
  const _VenueHeroHeader({required this.venue});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Stack(
      children: [
        SizedBox(
          height: 220 + top,
          width: double.infinity,
          child: venue.imageUrl.isNotEmpty
              ? venue.imageUrl.startsWith('assets/')
                  ? Image.asset(venue.imageUrl, fit: BoxFit.cover)
                  : Image.network(venue.imageUrl, fit: BoxFit.cover)
              : Container(color: AppColors.primarySurface),
        ),
        // Dark gradient
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.55),
                  Colors.black.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Back button
        Positioned(
          top: top + 8,
          left: 8,
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            ),
            onPressed: () => context.pop(),
          ),
        ),
        // Venue name & info overlay at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.75),
                  Colors.transparent,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SportChip(sport: venue.sport),
                const SizedBox(height: 6),
                Text(
                  venue.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 13, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text(
                      venue.address,
                      style: const TextStyle(color: Colors.white70, fontSize: 12.5),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '₹${venue.pricePerHour.toStringAsFixed(0)}/hr',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SportChip extends StatelessWidget {
  final String sport;
  const _SportChip({required this.sport});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
      ),
      child: Text(
        sport,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
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
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.calendar_today_outlined,
                size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          Text(
            DateFormatter.toDisplayFormat(selectedDate),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
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
                    colorScheme: const ColorScheme.light(primary: AppColors.primary),
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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                AppStrings.selectDate,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
