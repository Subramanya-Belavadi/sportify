import 'package:equatable/equatable.dart';

class VenueEntity extends Equatable {
  final String id;
  final String name;
  final String address;
  final String sport;
  final String imageUrl;
  final double pricePerHour;

  const VenueEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.sport,
    required this.imageUrl,
    required this.pricePerHour,
  });

  @override
  List<Object?> get props => [id, name, address, sport, imageUrl, pricePerHour];
}
