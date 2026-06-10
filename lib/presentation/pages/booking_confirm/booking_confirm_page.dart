import 'dart:async';
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
  int get duration => (args['duration'] as int?) ?? 1;
  String get endTime => (args['endTime'] as String?) ?? slot.endTime;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BookingBloc>(),
      child: _ConfirmView(
          venue: venue, slot: slot, duration: duration, endTime: endTime),
    );
  }
}

class _ConfirmView extends StatefulWidget {
  final VenueEntity venue;
  final SlotEntity slot;
  final int duration;
  final String endTime;
  const _ConfirmView(
      {required this.venue,
      required this.slot,
      required this.duration,
      required this.endTime});

  @override
  State<_ConfirmView> createState() => _ConfirmViewState();
}

class _ConfirmViewState extends State<_ConfirmView> {
  Timer? _countdownTimer;
  int _secondsLeft = 120;
  bool _reserving = true;
  String? _reserveError;

  @override
  void initState() {
    super.initState();
    _reserveSlot();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _reserveSlot() async {
    try {
      await sl<ApiClient>().reserveSlot(widget.venue.id, widget.slot.id);
      if (!mounted) return;
      setState(() => _reserving = false);
      _startCountdown();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _reserving = false;
        _reserveError = 'This slot is no longer available.';
      });
    }
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) {
        t.cancel();
        _onExpired();
      }
    });
  }

  void _onExpired() {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Reservation Expired',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text(
            'Your 2-minute hold has expired. Please select the slot again.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('Go Back',
                style: TextStyle(
                    color: AppColors.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  String get _timerLabel {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Color get _timerColor {
    if (_secondsLeft > 60) return AppColors.slotAvailable;
    if (_secondsLeft > 30) return const Color(0xFFE65100);
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingSuccess) {
          _countdownTimer?.cancel();
          context.go(AppRouter.bookingSuccess,
              extra: {'booking': state.booking});
        } else if (state is BookingSlotTaken) {
          _countdownTimer?.cancel();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Text('Cannot Book Slot',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              content: Text(state.message),
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
            onPressed: () {
              _countdownTimer?.cancel();
              context.pop();
            },
          ),
          title: const Text(
            AppStrings.confirmBooking,
            style: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.w700),
          ),
          actions: [
            if (!_reserving && _reserveError == null)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: _timerColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: _timerColor.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.timer_outlined,
                            size: 14, color: _timerColor),
                        const SizedBox(width: 4),
                        Text(
                          _timerLabel,
                          style: TextStyle(
                            color: _timerColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        body: _reserving
            ? const Center(child: CircularProgressIndicator())
            : _reserveError != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 48, color: AppColors.error),
                          const SizedBox(height: 16),
                          Text(_reserveError!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 15)),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => context.pop(),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white),
                            child: const Text('Go Back'),
                          ),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _VenueImageCard(venue: widget.venue),
                        const SizedBox(height: 16),
                        _BookingDetailsCard(
                            venue: widget.venue,
                            slot: widget.slot,
                            endTime: widget.endTime,
                            duration: widget.duration),
                        const SizedBox(height: 16),
                        _PriceBreakdown(
                            pricePerHour: widget.venue.pricePerHour,
                            duration: widget.duration),
                        const Spacer(),
                        BlocBuilder<BookingBloc, BookingState>(
                          builder: (context, state) {
                            final loading = state is BookingLoading;
                            return ElevatedButton(
                              onPressed: loading
                                  ? null
                                  : () =>
                                      context.read<BookingBloc>().add(BookSlot(
                                            slotId: widget.slot.id,
                                            userId: sl<ApiClient>()
                                                    .currentUserId ??
                                                '',
                                            durationHours: widget.duration,
                                          )),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(54),
                                elevation: 3,
                                shadowColor:
                                    AppColors.primary.withValues(alpha: 0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: loading
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white),
                                    )
                                  : const Text(
                                      'Confirm Booking',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
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
  final String endTime;
  final int duration;
  const _BookingDetailsCard(
      {required this.venue,
      required this.slot,
      required this.endTime,
      required this.duration});

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
          const Text('Booking Details',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 14),
          _DetailRow(
              icon: Icons.location_on_outlined,
              label: 'Venue',
              value: venue.address),
          const Divider(height: 20, color: AppColors.divider),
          _DetailRow(
              icon: Icons.calendar_today_outlined,
              label: 'Date',
              value: DateFormatter.toDisplayFormat(
                  DateTime.parse(slot.date))),
          const Divider(height: 20, color: AppColors.divider),
          _DetailRow(
              icon: Icons.access_time_outlined,
              label: 'Time',
              value: DateFormatter.slotRange(slot.startTime, endTime)),
          const Divider(height: 20, color: AppColors.divider),
          _DetailRow(
              icon: Icons.timelapse_outlined,
              label: 'Duration',
              value: '$duration ${duration == 1 ? 'hour' : 'hours'}'),
          const Divider(height: 20, color: AppColors.divider),
          _DetailRow(
              icon: Icons.sports_outlined,
              label: 'Sport',
              value: venue.sport),
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

class _PriceBreakdown extends StatelessWidget {
  final double pricePerHour;
  final int duration;
  const _PriceBreakdown(
      {required this.pricePerHour, required this.duration});

  @override
  Widget build(BuildContext context) {
    final base = pricePerHour * duration;
    final gst = base * 0.18;
    final total = base + gst;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 14,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Price Breakdown',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 14),
          _PriceRow(
              label:
                  '₹${pricePerHour.toStringAsFixed(0)} × $duration ${duration == 1 ? 'hr' : 'hrs'}',
              value: '₹${base.toStringAsFixed(0)}',
              bold: false),
          const SizedBox(height: 8),
          _PriceRow(
              label: 'GST (18%)',
              value: '₹${gst.toStringAsFixed(0)}',
              bold: false),
          const Divider(height: 20, color: AppColors.divider),
          _PriceRow(
              label: 'Total',
              value: '₹${total.toStringAsFixed(0)}',
              bold: true),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _PriceRow(
      {required this.label, required this.value, required this.bold});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label,
            style: TextStyle(
                fontSize: bold ? 15 : 13,
                color: bold
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontWeight:
                    bold ? FontWeight.w800 : FontWeight.w400)),
        const Spacer(),
        Text(value,
            style: TextStyle(
                fontSize: bold ? 18 : 13,
                color: bold ? AppColors.primary : AppColors.textPrimary,
                fontWeight:
                    bold ? FontWeight.w800 : FontWeight.w600)),
      ],
    );
  }
}
