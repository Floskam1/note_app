import 'package:note_app/core/failure/failures.dart' as failures;

sealed class Result<T> {
  const Result();

  factory Result.success(T value) = Success;
  factory Result.failure(failures.Failure failure) = Failure;
  
  R when<R>({
    required R Function(T data) success,
    required R Function(failures.Failure failure) error,
  }) {
    return switch (this) {
      Success<T>(:final value) => success(value),
      Failure<T>(:final failure) => error(failure),
    };
  }
}

final class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

final class Failure<T> extends Result<T> {
  final failures.Failure failure;
  const Failure(this.failure);
}
