abstract class Failure {
  final String message;
  
  const Failure(this.message);
  
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}
