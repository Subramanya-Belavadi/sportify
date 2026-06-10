import 'package:go_router/go_router.dart';
import '../../core/di/injection_container.dart';
import '../../core/network/api_client.dart';
import '../../domain/entities/venue_entity.dart';
import '../pages/booking_confirm/booking_confirm_page.dart';
import '../pages/login/login_page.dart';
import '../pages/signup/signup_page.dart';
import '../pages/my_bookings/my_bookings_page.dart';
import '../pages/profile/profile_page.dart';
import '../pages/shell/main_shell.dart';
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
  static const String profile = '/profile';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    redirect: (context, state) {
      final loggedIn = sl<ApiClient>().currentUserId != null;
      final onAuth = state.matchedLocation == login || state.matchedLocation == signup;
      if (loggedIn && onAuth) return venueList;
      return null;
    },
    routes: [
      GoRoute(path: login, builder: (c, s) => const LoginPage()),
      GoRoute(path: signup, builder: (c, s) => const SignupPage()),
      GoRoute(
        path: bookingConfirm,
        builder: (c, s) =>
            BookingConfirmPage(args: s.extra as Map<String, dynamic>),
      ),
      GoRoute(
        path: venueDetail,
        builder: (c, s) {
          final venue = s.extra as VenueEntity;
          return VenueDetailPage(
              venueId: s.pathParameters['id']!, venue: venue);
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (c, s, shell) => MainShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: venueList,
                builder: (c, s) => const VenueListPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: myBookings, builder: (c, s) => const MyBookingsPage()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: profile, builder: (c, s) => const ProfilePage()),
            ],
          ),
        ],
      ),
    ],
  );
}
