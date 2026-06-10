import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/network/api_client.dart';
import '../../blocs/booking/booking_bloc.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import 'widgets/booking_card.dart';

class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = sl<ApiClient>().currentUserId ?? '';
    return BlocProvider(
      create: (_) => sl<BookingBloc>()..add(LoadUserBookings(userId)),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            AppStrings.myBookings,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocConsumer<BookingBloc, BookingState>(
          listener: (context, state) {
            if (state is BookingCancelled) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(AppStrings.bookingCancelled),
                  backgroundColor: AppColors.success,
                ),
              );
              context.read<BookingBloc>().add(LoadUserBookings(userId));
            } else if (state is BookingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is BookingLoading) return const LoadingWidget();
            if (state is BookingError) {
              return AppErrorWidget(
                message: state.message,
                onRetry: () =>
                    context.read<BookingBloc>().add(LoadUserBookings(userId)),
              );
            }
            if (state is UserBookingsLoaded) {
              if (state.bookings.isEmpty) {
                return const EmptyStateWidget(
                  message: AppStrings.noBookings,
                  icon: Icons.calendar_today_outlined,
                );
              }
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async =>
                    context.read<BookingBloc>().add(LoadUserBookings(userId)),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  itemCount: state.bookings.length,
                  itemBuilder: (context, i) {
                    final b = state.bookings[i];
                    return BookingCard(
                      booking: b,
                      onCancel: () => _confirmCancel(context, b.id),
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _confirmCancel(BuildContext context, String bookingId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(AppStrings.cancelBooking,
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text(AppStrings.cancelConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.no),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<BookingBloc>().add(
                    CancelBooking(
                      bookingId: bookingId,
                      userId: sl<ApiClient>().currentUserId ?? '',
                    ),
                  );
            },
            child: const Text(AppStrings.yes,
                style: TextStyle(
                    color: AppColors.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
