import 'package:get_it/get_it.dart';
import '../../data/datasources/remote/booking_remote_datasource.dart';
import '../../data/datasources/remote/slot_remote_datasource.dart';
import '../../data/datasources/remote/venue_remote_datasource.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../data/repositories/slot_repository_impl.dart';
import '../../data/repositories/venue_repository_impl.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../domain/repositories/slot_repository.dart';
import '../../domain/repositories/venue_repository.dart';
import '../../presentation/blocs/booking/booking_bloc.dart';
import '../../presentation/blocs/slot/slot_bloc.dart';
import '../../presentation/blocs/venue/venue_bloc.dart';
import '../network/api_client.dart';
import '../storage/auth_storage.dart';

final sl = GetIt.instance;

void setupDependencies() {
  sl.registerLazySingleton<AuthStorage>(() => AuthStorage());
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  sl.registerLazySingleton<VenueRemoteDatasource>(() => VenueRemoteDatasourceImpl(sl()));
  sl.registerLazySingleton<SlotRemoteDatasource>(() => SlotRemoteDatasourceImpl(sl()));
  sl.registerLazySingleton<BookingRemoteDatasource>(() => BookingRemoteDatasourceImpl(sl()));

  sl.registerLazySingleton<VenueRepository>(() => VenueRepositoryImpl(sl()));
  sl.registerLazySingleton<SlotRepository>(() => SlotRepositoryImpl(sl()));
  sl.registerLazySingleton<BookingRepository>(() => BookingRepositoryImpl(sl()));

  sl.registerFactory(() => VenueBloc(sl()));
  sl.registerFactory(() => SlotBloc(sl()));
  sl.registerFactory(() => BookingBloc(sl()));
}
