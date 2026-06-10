import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../domain/entities/venue_entity.dart';

class VenueCard extends StatelessWidget {
  final VenueEntity venue;
  final VoidCallback onTap;
  const VenueCard({super.key, required this.venue, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _VenueImage(imageUrl: venue.imageUrl, sport: venue.sport),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          venue.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                        ),
                      ),
                      _SportBadge(sport: venue.sport),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          venue.address,
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '₹${venue.pricePerHour.toStringAsFixed(0)}/hr',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                        ),
                        child: const Text(
                          'Book Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VenueImage extends StatelessWidget {
  final String imageUrl;
  final String sport;
  const _VenueImage({required this.imageUrl, required this.sport});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusLG)),
      child: Container(
        height: AppDimensions.venueCardHeight,
        width: double.infinity,
        color: AppColors.primarySurface,
        child: imageUrl.isNotEmpty
            ? imageUrl.startsWith('assets/')
                ? Image.asset(imageUrl, fit: BoxFit.cover)
                : Image.network(imageUrl, fit: BoxFit.cover)
            : Center(
                child: Icon(
                  _iconForSport(sport),
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
      ),
    );
  }
}

IconData _iconForSport(String sport) {
  switch (sport) {
    case 'Football':
      return Icons.sports_soccer;
    case 'Box Cricket':
      return Icons.sports_cricket;
    case 'Pickleball':
      return Icons.sports_tennis;
    default:
      return Icons.sports_tennis;
  }
}

class _SportBadge extends StatelessWidget {
  final String sport;
  const _SportBadge({required this.sport});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        sport,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
