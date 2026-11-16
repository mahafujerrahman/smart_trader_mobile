// Failure classes — previously built on Equatable, which is not a
// dependency of this project. Equality is now implemented manually
// (same semantics: failures are equal when type + message match).

abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() => '$runtimeType: $message';
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(
      [super.message = 'No internet connection. Please check your network.']);
}

class AuthFailure extends Failure {
  const AuthFailure(
      [super.message = 'Authentication failed. Please login again.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local storage error.']);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred.']);
}
