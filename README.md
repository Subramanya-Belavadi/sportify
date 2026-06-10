# Sportify

A Flutter sports venue booking app that lets users discover, filter, and book sports courts in real time — with live slot reservation, countdown timers, and an instant booking confirmation flow.

---

## Features

### Authentication
- Email & password sign up / login
- Password rules: 8+ characters, must contain a letter, a digit, and one symbol
- Session persisted with `flutter_secure_storage` — auto-login on relaunch
- Sign out clears all stored credentials and redirects to login

### Venue Discovery
- Browse 6 venues across 4 sports (Badminton, Football, Box Cricket, Pickleball)
- Sport filter chips — tap to filter, tap again to deselect
- Pull-to-refresh venue list
- Venue cards show name, location, sport badge, and price per hour

### Slot Booking
- Full-screen venue detail (no bottom nav bar)
- Hero image header with venue info overlay
- Date picker — defaults to today; auto-advances to tomorrow if current time is 9 PM or later
- Hour-grid slot selector (6 AM – 10 PM) with 5 visual states:

| State | Colour | Meaning |
|-------|--------|---------|
| Open | Green | Available to book |
| Booked | Red | Taken by another user |
| Yours | Orange | Already booked by you at this venue |
| Past | Grey | Hour has already passed |
| Selected | Blue | Currently chosen |

- Duration selector (1–4 hrs) capped to consecutive available hours
- Real-time price (base + 18% GST) updates as duration changes

### Live Slot Reservation (2-Minute Hold)
- Tapping "Book" sends a server-side reservation request that locks the slot for 2 minutes
- Countdown timer displayed in the AppBar, colour-coded:
  - Green — more than 60 seconds left
  - Orange — 30–60 seconds left
  - Red — under 30 seconds
- If the timer expires an alert is shown and the user is returned to slot selection
- The hold is automatically released on the backend if the booking is not confirmed

### Booking Confirmation
- Venue image, full booking details (venue, address, date, time, duration, sport)
- Price breakdown: base amount + 18% GST = total payable
- "Pay at the Venue" model — no online payment required
- Loading spinner during booking; graceful error handling if the slot is taken

### Booking Success
- Green check-circle confirmation screen
- Shareable booking summary via the native share sheet
- Two actions: **Home** and **My Bookings**
- Back navigation blocked to prevent accidental re-submission

### My Bookings
- Full booking history with status badges (Confirmed / Cancelled)
- Per-card breakdown: date, time, duration, sport icon, price breakdown
- Cancel confirmed bookings with a confirmation dialog
- Pull-to-refresh

### Profile
- Displays user name and email
- Quick link to My Bookings
- Sign out with confirmation prompt

---

## Screens & Navigation

```
/                    Login
/signup              Sign Up
    │
    └──► /venues                 Venue List  (Tab 1)
             │
             └──► /venues/:id   Venue Detail
                      │
                      └──► /booking/confirm   Booking Confirm
                                 │
                                 └──► /booking/success   Booking Success
                                          ├── Home  →  /venues
                                          └── My Bookings → /my-bookings

         /my-bookings            My Bookings (Tab 2)
         /profile                Profile     (Tab 3)
```

Venue detail, booking confirm, and booking success are rendered outside the bottom-nav shell so the navigation bar is hidden on those screens.

---

## Architecture

Clean Architecture with three layers:

```
lib/
├── core/
│   ├── constants/        # Colors, strings, image paths
│   ├── di/               # GetIt service locator
│   ├── errors/           # Exceptions and failures
│   ├── network/          # ApiClient (Dio), endpoints
│   ├── storage/          # AuthStorage (flutter_secure_storage)
│   └── utils/            # DateFormatter
│
├── domain/
│   ├── entities/         # VenueEntity, SlotEntity, BookingEntity
│   └── repositories/     # Abstract repository interfaces
│
├── data/
│   ├── models/           # JSON deserialization (VenueModel, SlotModel, BookingModel)
│   ├── datasources/      # Remote datasource implementations
│   └── repositories/     # Repository implementations
│
└── presentation/
    ├── blocs/            # VenueBloc, SlotBloc, BookingBloc
    ├── pages/            # One folder per screen
    ├── router/           # GoRouter configuration
    └── widgets/          # Shared widgets (loading, error, empty state)
```

### BLoC Summary

**VenueBloc** — `LoadVenues` · `FilterVenues(sport?)` · `SearchVenues(query)`
→ `VenueLoading` · `VenueLoaded` · `VenueError`

`VenueLoaded` exposes computed `venues` (filtered list) and `sports` (unique sport names) getters so no extra events are needed for filtering.

**SlotBloc** — `LoadSlots` · `SelectSlot` · `SelectDuration(hours)`
→ `SlotLoading` · `SlotLoaded` · `SlotError`

`SlotLoaded` computes `selectedSlots` (all slots spanning the chosen duration) and `maxDuration` (longest consecutive available run from the anchor slot).

**BookingBloc** — `BookSlot` · `LoadUserBookings` · `CancelBooking`
→ `BookingLoading` · `BookingSuccess` · `BookingSlotTaken` · `BookingError` · `UserBookingsLoaded` · `BookingCancelled`

---

## Domain Entities

### VenueEntity
| Field | Type | Description |
|-------|------|-------------|
| id | String | Unique identifier |
| name | String | Venue name |
| address | String | Location |
| sport | String | Sport type |
| imageUrl | String | Asset path or network URL |
| pricePerHour | double | Hourly rate (₹) |

### SlotEntity
| Field | Type | Description |
|-------|------|-------------|
| id | String | Format: `{venueId}_{date}_{HH}` |
| venueId | String | Parent venue |
| date | String | `yyyy-MM-dd` |
| startTime | String | `HH:mm` |
| endTime | String | `HH:mm` |
| status | String | `available` / `booked` / `reserved` |
| bookedBy | String? | User ID if booked |
| isAvailable | bool | Computed: `status == 'available'` |

### BookingEntity
| Field | Type | Description |
|-------|------|-------------|
| id | String | UUID |
| userId | String | Booker |
| slotId | String | First slot ID |
| venueId | String | Venue |
| venueName | String | Cached venue name |
| date | String | `yyyy-MM-dd` |
| startTime | String | `HH:mm` |
| endTime | String | `HH:mm` |
| durationHours | int | 1–4 |
| baseAmount | double | Price before tax |
| gstAmount | double | 18% GST |
| totalAmount | double | Total payable |
| status | String | `confirmed` / `cancelled` |
| createdAt | String | ISO timestamp |

---

## Tech Stack

| Concern | Package |
|---------|---------|
| State management | flutter_bloc 8 |
| Navigation | go_router 14 |
| HTTP | dio 5 |
| Dependency injection | get_it 8 |
| Secure storage | flutter_secure_storage 9 |
| Sharing | share_plus 10 |
| Env config | flutter_dotenv |
| Date formatting | intl |

---

## Setup

### 1. Environment

Create `.env` in the project root:

```env
API_BASE_URL=http://<backend-host>:8000
```

- Android emulator → `http://10.0.2.2:8000`
- Physical device → your machine's local IP, e.g. `http://192.168.1.5:8000`

### 2. Run

```bash
flutter pub get
flutter run
```
