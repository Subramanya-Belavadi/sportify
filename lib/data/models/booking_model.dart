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
    required super.durationHours,
    required super.baseAmount,
    required super.gstAmount,
    required super.totalAmount,
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
        durationHours: (json['duration_hours'] as num?)?.toInt() ?? 1,
        baseAmount: (json['base_amount'] as num?)?.toDouble() ?? 0,
        gstAmount: (json['gst_amount'] as num?)?.toDouble() ?? 0,
        totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
        status: json['status'] as String,
        createdAt: json['created_at'] as String,
      );
}
