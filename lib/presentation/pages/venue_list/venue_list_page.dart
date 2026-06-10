import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/di/injection_container.dart';
import '../../blocs/venue/venue_bloc.dart';
import '../../router/app_router.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import 'widgets/venue_card.dart';

class VenueListPage extends StatelessWidget {
  const VenueListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VenueBloc>()..add(const LoadVenues()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.appName),
          actions: [
            IconButton(
              icon: const Icon(Icons.calendar_month_outlined),
              tooltip: AppStrings.myBookings,
              onPressed: () => context.push(AppRouter.myBookings),
            ),
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              tooltip: 'Logout',
              onPressed: () => context.go(AppRouter.login),
            ),
          ],
        ),
        body: BlocBuilder<VenueBloc, VenueState>(
          builder: (context, state) {
            if (state is VenueLoading) return const LoadingWidget();
            if (state is VenueError) {
              return AppErrorWidget(
                message: state.message,
                onRetry: () => context.read<VenueBloc>().add(const LoadVenues()),
              );
            }
            if (state is VenueLoaded) {
              if (state.venues.isEmpty) {
                return const EmptyStateWidget(
                  message: AppStrings.noVenuesFound,
                  icon: Icons.stadium_outlined,
                );
              }
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async =>
                    context.read<VenueBloc>().add(const LoadVenues()),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.venues.length,
                  itemBuilder: (context, i) {
                    final venue = state.venues[i];
                    return VenueCard(
                      venue: venue,
                      onTap: () => context.push(
                        '/venues/${venue.id}',
                        extra: venue,
                      ),
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
}
