enum FailureType { general, server, cache, connection }

class Failure {
  final String message;
  final FailureType type;

  const Failure(this.message, [this.type = FailureType.general]);

  const Failure.server(String msg) : this(msg, FailureType.server);
  const Failure.cache(String msg) : this(msg, FailureType.cache);
  const Failure.connection(String msg) : this(msg, FailureType.connection);
}