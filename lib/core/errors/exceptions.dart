class ServerException implements Exception {
  final String message;
  final int? statusCode;
  const ServerException({required this.message, this.statusCode});
}

class NetworkException implements Exception {
  const NetworkException();
}

class SlotAlreadyTakenException implements Exception {
  final String message;
  const SlotAlreadyTakenException([this.message = 'This slot is no longer available.']);
}
