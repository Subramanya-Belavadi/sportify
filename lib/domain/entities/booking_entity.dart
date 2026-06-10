import 'package:equatable/equatable.dart';

class BookingEntity extends Equatable {
  final String id;
  final String userId;
  final String slotId;
  final String venueId;
  final String venueName;
  final String date;
  final String startTime;
  final String endTime;
  final String status;
  final String createdAt;

  const BookingEntity({
    required this.id,
    required this.userId,
    required this.slotId,
    required this.venueId,
    required this.venueName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, slotId, venueId, date, startTime, endTime, status];
}
