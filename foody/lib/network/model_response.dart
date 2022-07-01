abstract class Result<T> {}

class Success<T> extends Result<T> {
  T value;
  Success(this.value);
}

class Error<T> extends Result<T> {
  Exception exception;
  Error(this.exception);
}
