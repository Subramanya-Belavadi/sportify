import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/di/injection_container.dart';
import '../../blocs/venue/venue_bloc.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import 'widgets/venue_card.dart';

class VenueListPage extends StatefulWidget {
  const VenueListPage({super.key});

  @override
  State<VenueListPage> createState() => _VenueListPageState();
}

class _VenueListPageState extends State<VenueListPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VenueBloc>()..add(const LoadVenues()),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F6FA),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.primary,
            elevation: 0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1a2850), AppColors.primary],
                ),
              ),
            ),
            title: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    AppImages.logo,
                    fit: BoxFit.contain,
                    errorBuilder: (_, e, s) => const Icon(
                      Icons.sports_tennis_rounded,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.appName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      'Find and book venues',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
                return Column(
                  children: [
                    // Filter chips
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _FilterChip(
                              label: 'All',
                              selected: state.selectedSport == null,
                              onTap: () => context.read<VenueBloc>().add(const FilterVenues(null)),
                            ),
                            const SizedBox(width: 8),
                            ...state.sports.map((sport) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: _FilterChip(
                                label: sport,
                                selected: state.selectedSport == sport,
                                onTap: () => context.read<VenueBloc>().add(FilterVenues(sport)),
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    Expanded(
                      child: state.venues.isEmpty
                          ? const EmptyStateWidget(
                              message: AppStrings.noVenuesFound,
                              icon: Icons.stadium_outlined,
                            )
                          : RefreshIndicator(
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
                            ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        );
      }),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.primarySurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
