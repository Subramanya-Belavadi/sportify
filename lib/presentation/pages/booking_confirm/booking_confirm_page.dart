import 'package:flutter/material.dart';

class BookingConfirmPage extends StatelessWidget {
  final Map<String, dynamic> args;
  const BookingConfirmPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    // TODO: implement confirm screen + handle slot-taken error
    return const Scaffold(body: Center(child: Text('Confirm Booking')));
  }
}
