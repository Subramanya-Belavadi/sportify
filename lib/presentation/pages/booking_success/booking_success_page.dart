import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/booking_entity.dart';
import '../../router/app_router.dart';

class BookingSuccessPage extends StatelessWidget {
  final Map<String, dynamic> args;
  const BookingSuccessPage({super.key, required this.args});

  BookingEntity get booking => args['booking'] as BookingEntity;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                // Success animation
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.slotAvailable.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.slotAvailable,
                    size: 56,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Booking Confirmed!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                // Pay at venue badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFFB300).withValues(alpha: 0.6)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.payments_outlined, size: 16, color: Color(0xFFE65100)),
                      SizedBox(width: 6),
                      Text(
                        'Pay at the Venue',
                        style: TextStyle(
                          color: Color(0xFFE65100),
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                // Booking details card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _BookingRow(
                        icon: Icons.stadium_rounded,
                        label: 'Venue',
                        value: booking.venueName,
                      ),
                      const Divider(height: 20, color: AppColors.divider),
                      _BookingRow(
                        icon: Icons.calendar_today_rounded,
                        label: 'Date',
                        value: DateFormatter.toDisplayFormat(DateTime.parse(booking.date)),
                      ),
                      const Divider(height: 20, color: AppColors.divider),
                      _BookingRow(
                        icon: Icons.access_time_rounded,
                        label: 'Time',
                        value: DateFormatter.slotRange(booking.startTime, booking.endTime),
                      ),
                      const Divider(height: 20, color: AppColors.divider),
                      _BookingRow(
                        icon: Icons.timelapse_rounded,
                        label: 'Duration',
                        value: '${booking.durationHours} ${booking.durationHours == 1 ? 'hour' : 'hours'}',
                      ),
                      const Divider(height: 20, color: AppColors.divider),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Payable',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary)),
                          Text(
                            '₹${booking.totalAmount.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Share button
                OutlinedButton.icon(
                  onPressed: () => _shareBooking(context),
                  icon: const Icon(Icons.share_outlined, size: 18),
                  label: const Text('Share Booking'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const Spacer(),
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.go(AppRouter.venueList),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Home',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => context.go(AppRouter.myBookings),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(52),
                          elevation: 3,
                          shadowColor: AppColors.primary.withValues(alpha: 0.4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('My Bookings',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _shareBooking(BuildContext context) {
    final date = DateFormatter.toDisplayFormat(DateTime.parse(booking.date));
    final time = DateFormatter.slotRange(booking.startTime, booking.endTime);
    final text = '''🏟️ Slot Booked on Sportify!

Venue: ${booking.venueName}
📅 Date: $date
⏰ Time: $time
⏱ Duration: ${booking.durationHours} ${booking.durationHours == 1 ? 'hour' : 'hours'}
💰 Total: ₹${booking.totalAmount.toStringAsFixed(0)}

💳 Pay at the Venue
''';
    Share.share(text, subject: 'My Sportify Booking');
  }
}

class _BookingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _BookingRow(
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
            ],
          ),
        ),
      ],
    );
  }
}
