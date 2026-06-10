import '../../domain/entities/booking_entity.dart';

class BookingModel extends BookingEntity {
  const BookingModel({
    required super.id,
    required super.userId,
    required super.slotId,
    required super.venueId,
    required super.venueName,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.status,
    required super.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        slotId: json['slot_id'] as String,
        venueId: json['venue_id'] as String,
        venueName: json['venue_name'] as String? ?? '',
        date: json['date'] as String,
        startTime: json['start_time'] as String,
        endTime: json['end_time'] as String,
        status: json['status'] as String,
        createdAt: json['created_at'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'slot_id': slotId,
        'venue_id': venueId,
        'venue_name': venueName,
        'date': date,
        'start_time': startTime,
        'end_time': endTime,
        'status': status,
        'created_at': createdAt,
      };
}
