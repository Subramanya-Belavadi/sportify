import '../../domain/entities/venue_entity.dart';

class VenueModel extends VenueEntity {
  const VenueModel({
    required super.id,
    required super.name,
    required super.address,
    required super.sport,
    required super.imageUrl,
    required super.pricePerHour,
  });

  factory VenueModel.fromJson(Map<String, dynamic> json) => VenueModel(
        id: json['id'] as String,
        name: json['name'] as String,
        address: json['address'] as String,
        sport: json['sport'] as String,
        imageUrl: json['image_url'] as String? ?? '',
        pricePerHour: (json['price_per_hour'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'sport': sport,
        'image_url': imageUrl,
        'price_per_hour': pricePerHour,
      };
}
