import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
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
                  borderRadius: BorderRadius.circular(20)),
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
        backgroundColor: const Color(0xFFF5F6FA),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            AppStrings.confirmBooking,
            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Venue image card
              _VenueImageCard(venue: venue),
              const SizedBox(height: 16),
              // Booking details card
              _BookingDetailsCard(venue: venue, slot: slot),
              const Spacer(),
              // Price summary
              _PriceSummary(price: venue.pricePerHour),
              const SizedBox(height: 16),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(54),
                      elevation: 3,
                      shadowColor: AppColors.primary.withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: loading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(
                            'Confirm Booking',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
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

class _VenueImageCard extends StatelessWidget {
  final VenueEntity venue;
  const _VenueImageCard({required this.venue});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          SizedBox(
            height: 160,
            width: double.infinity,
            child: venue.imageUrl.isNotEmpty
                ? venue.imageUrl.startsWith('assets/')
                    ? Image.asset(venue.imageUrl, fit: BoxFit.cover)
                    : Image.network(venue.imageUrl, fit: BoxFit.cover)
                : Container(color: AppColors.primarySurface),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 14,
            left: 16,
            right: 16,
            child: Text(
              venue.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingDetailsCard extends StatelessWidget {
  final VenueEntity venue;
  final SlotEntity slot;
  const _BookingDetailsCard({required this.venue, required this.slot});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking Details',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          _DetailRow(
            icon: Icons.location_on_outlined,
            label: 'Venue',
            value: venue.address,
          ),
          const Divider(height: 20, color: AppColors.divider),
          _DetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'Date',
            value: DateFormatter.toDisplayFormat(DateTime.parse(slot.date)),
          ),
          const Divider(height: 20, color: AppColors.divider),
          _DetailRow(
            icon: Icons.access_time_outlined,
            label: 'Time',
            value: DateFormatter.slotRange(slot.startTime, slot.endTime),
          ),
          const Divider(height: 20, color: AppColors.divider),
          _DetailRow(
            icon: Icons.sports_outlined,
            label: 'Sport',
            value: venue.sport,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary)),
            Text(value,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
          ],
        ),
      ],
    );
  }
}

class _PriceSummary extends StatelessWidget {
  final double price;
  const _PriceSummary({required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Text(
            'Total Amount',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            '₹${price.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
