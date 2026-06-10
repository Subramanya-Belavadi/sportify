import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/slot_entity.dart';
import '../../../domain/entities/venue_entity.dart';
import '../../blocs/booking/booking_bloc.dart';
import '../../router/app_router.dart';

class BookingConfirmPage extends StatelessWidget {
  final Map<String, dynamic> args;
  const BookingConfirmPage({super.key, required this.args});

  VenueEntity get venue => args['venue'] as VenueEntity;
  SlotEntity get slot => args['slot'] as SlotEntity;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BookingBloc>(),
      child: _ConfirmView(venue: venue, slot: slot),
    );
  }
}

class _ConfirmView extends StatelessWidget {
  final VenueEntity venue;
  final SlotEntity slot;
  const _ConfirmView({required this.venue, required this.slot});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.bookingSuccess),
              backgroundColor: AppColors.success,
            ),
          );
          context.go(AppRouter.myBookings);
        } else if (state is BookingSlotTaken) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLG)),
              title: const Text('Slot Unavailable'),
              content: const Text(AppStrings.slotAlreadyTaken),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.pop();
                  },
                  child: const Text(AppStrings.goBack),
                ),
              ],
            ),
          );
        } else if (state is BookingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text(AppStrings.confirmBooking)),
        body: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SummaryCard(venue: venue, slot: slot),
              const Spacer(),
              BlocBuilder<BookingBloc, BookingState>(
                builder: (context, state) {
                  final loading = state is BookingLoading;
                  return ElevatedButton(
                    onPressed: loading
                        ? null
                        : () => context.read<BookingBloc>().add(
                              BookSlot(
                                slotId: slot.id,
                                userId: sl<ApiClient>().currentUserId ?? '',
                              ),
                            ),
                    child: loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(AppStrings.confirmBooking),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final VenueEntity venue;
  final SlotEntity slot;
  const _SummaryCard({required this.venue, required this.slot});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            venue.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
          const Divider(height: 24, color: AppColors.divider),
          _Row(icon: Icons.location_on_outlined, label: venue.address),
          const SizedBox(height: 10),
          _Row(
            icon: Icons.calendar_today_outlined,
            label: DateFormatter.toDisplayFormat(DateTime.parse(slot.date)),
          ),
          const SizedBox(height: 10),
          _Row(
            icon: Icons.access_time_outlined,
            label: DateFormatter.slotRange(slot.startTime, slot.endTime),
          ),
          const SizedBox(height: 10),
          _Row(
            icon: Icons.currency_rupee,
            label: '₹${venue.pricePerHour.toStringAsFixed(0)}',
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Row({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(label,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
        ),
      ],
    );
  }
}
