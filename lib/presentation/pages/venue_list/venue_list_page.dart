import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/storage/auth_storage.dart';
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
        backgroundColor: const Color(0xFFF5F6FA),
        body: NestedScrollView(
          headerSliverBuilder: (context, _) => [
            SliverAppBar(
              expandedHeight: 130,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1a2850), AppColors.primary],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      child: Row(
                        children: [
                          Image.asset(
                            AppImages.logo,
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                            errorBuilder: (_, e, s) => const Icon(
                              Icons.sports_tennis_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.appName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              Text(
                                'Find & book sports courts',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.calendar_month_outlined, color: Colors.white),
                  tooltip: AppStrings.myBookings,
                  onPressed: () => context.push(AppRouter.myBookings),
                ),
                IconButton(
                  icon: const Icon(Icons.logout_rounded, color: Colors.white),
                  tooltip: 'Logout',
                  onPressed: () async {
                    await sl<AuthStorage>().clear();
                    if (context.mounted) context.go(AppRouter.login);
                  },
                ),
              ],
            ),
          ],
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
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    itemCount: state.venues.length,
                    itemBuilder: (context, i) {
                      final venue = state.venues[i];
                      return VenueCard(
                        venue: venue,
                        onTap: () => context.push('/venues/${venue.id}', extra: venue),
                      );
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
