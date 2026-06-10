import 'package:flutter/material.dart';

class VenueDetailPage extends StatelessWidget {
  final String venueId;
  const VenueDetailPage({super.key, required this.venueId});

  @override
  Widget build(BuildContext context) {
    // TODO: implement date picker + slot grid with BLoC
    return const Scaffold(body: Center(child: Text('Venue Detail')));
  }
}
