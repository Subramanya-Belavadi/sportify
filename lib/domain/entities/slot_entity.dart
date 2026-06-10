import 'package:equatable/equatable.dart';

class SlotEntity extends Equatable {
  final String id;
  final String venueId;
  final String date;
  final String startTime;
  final String endTime;
  final String status; // 'available' | 'booked'
  final String? bookedBy;

  const SlotEntity({
    required this.id,
    required this.venueId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.bookedBy,
  });

  bool get isAvailable => status == 'available';

  @override
  List<Object?> get props => [id, venueId, date, startTime, endTime, status, bookedBy];
}
