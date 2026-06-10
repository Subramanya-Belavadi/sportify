import 'package:go_router/go_router.dart';
import '../../domain/entities/venue_entity.dart';
import '../pages/booking_confirm/booking_confirm_page.dart';
import '../pages/login/login_page.dart';
import '../pages/signup/signup_page.dart';
import '../pages/my_bookings/my_bookings_page.dart';
import '../pages/venue_detail/venue_detail_page.dart';
import '../pages/venue_list/venue_list_page.dart';

class AppRouter {
  AppRouter._();

  static const String login = '/';
  static const String signup = '/signup';
  static const String venueList = '/venues';
  static const String venueDetail = '/venues/:id';
  static const String bookingConfirm = '/booking/confirm';
  static const String myBookings = '/my-bookings';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    routes: [
      GoRoute(path: login, builder: (c, s) => const LoginPage()),
      GoRoute(path: signup, builder: (c, s) => const SignupPage()),
      GoRoute(path: venueList, builder: (c, s) => const VenueListPage()),
      GoRoute(
        path: venueDetail,
        builder: (c, s) {
          final venue = s.extra as VenueEntity;
          return VenueDetailPage(venueId: s.pathParameters['id']!, venue: venue);
        },
      ),
      GoRoute(
        path: bookingConfirm,
        builder: (c, s) =>
            BookingConfirmPage(args: s.extra as Map<String, dynamic>),
      ),
      GoRoute(path: myBookings, builder: (c, s) => const MyBookingsPage()),
    ],
  );
}
