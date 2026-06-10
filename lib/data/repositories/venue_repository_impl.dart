import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/venue_entity.dart';
import '../../domain/repositories/venue_repository.dart';
import '../datasources/remote/venue_remote_datasource.dart';

class VenueRepositoryImpl implements VenueRepository {
  final VenueRemoteDatasource _datasource;
  VenueRepositoryImpl(this._datasource);

  @override
  Future<List<VenueEntity>> getVenues() async {
    try {
      return await _datasource.getVenues();
    } on NetworkException {
      throw const NetworkFailure();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    }
  }

  @override
  Future<VenueEntity> getVenueById(String id) async {
    try {
      return await _datasource.getVenueById(id);
    } on NetworkException {
      throw const NetworkFailure();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    }
  }
}
