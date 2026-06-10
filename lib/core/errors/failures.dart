abstract class Failure {
  final String message;
  const Failure({required this.message});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super(message: 'Network error. Check your connection.');
}

class SlotAlreadyTakenFailure extends Failure {
  const SlotAlreadyTakenFailure([String message = 'This slot is no longer available.'])
      : super(message: message);
}
