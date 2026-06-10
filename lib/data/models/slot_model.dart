import '../../domain/entities/slot_entity.dart';

class SlotModel extends SlotEntity {
  const SlotModel({
    required super.id,
    required super.venueId,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.status,
    super.bookedBy,
  });

  factory SlotModel.fromJson(Map<String, dynamic> json) => SlotModel(
        id: json['id'] as String,
        venueId: json['venue_id'] as String,
        date: json['date'] as String,
        startTime: json['start_time'] as String,
        endTime: json['end_time'] as String,
        status: json['status'] as String,
        bookedBy: json['booked_by'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'venue_id': venueId,
        'date': date,
        'start_time': startTime,
        'end_time': endTime,
        'status': status,
        'booked_by': bookedBy,
      };
}
