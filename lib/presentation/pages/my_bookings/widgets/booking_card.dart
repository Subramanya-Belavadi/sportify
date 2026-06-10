import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../domain/entities/booking_entity.dart';

class BookingCard extends StatelessWidget {
  final BookingEntity booking;
  final VoidCallback onCancel;
  const BookingCard({super.key, required this.booking, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final isConfirmed = booking.status == 'confirmed';
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header strip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.08),
                  AppColors.primary.withValues(alpha: 0.03),
                ],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.sports_outlined,
                      size: 18, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    booking.venueName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                _StatusBadge(status: booking.status),
              ],
            ),
          ),
          // Details
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Expanded(
                  child: _InfoTile(
                    icon: Icons.calendar_today_outlined,
                    label: 'Date',
                    value: DateFormatter.toDisplayFormat(
                        DateTime.parse(booking.date)),
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.divider,
                ),
                Expanded(
                  child: _InfoTile(
                    icon: Icons.access_time_outlined,
                    label: 'Time',
                    value: DateFormatter.slotRange(
                        booking.startTime, booking.endTime),
                  ),
                ),
              ],
            ),
          ),
          if (isConfirmed)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.cancel_outlined,
                      size: 15, color: AppColors.error),
                  label: const Text(
                    'Cancel Booking',
                    style: TextStyle(
                        color: AppColors.error,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  ),
                ),
              ),
            ),
          if (!isConfirmed) const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoTile(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(label,
                  style: const TextStyle(
                      fontSize: 10.5, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isConfirmed = status == 'confirmed';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isConfirmed
            ? AppColors.slotAvailable.withValues(alpha: 0.12)
            : AppColors.slotBooked.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isConfirmed
              ? AppColors.slotAvailable.withValues(alpha: 0.4)
              : AppColors.slotBooked.withValues(alpha: 0.4),
        ),
      ),
      child: Text(
        isConfirmed ? 'Confirmed' : status,
        style: TextStyle(
          color: isConfirmed ? AppColors.slotAvailable : AppColors.slotBooked,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
