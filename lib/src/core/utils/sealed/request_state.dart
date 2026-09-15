sealed class RequestState {}

class InitialState extends RequestState {}

class LoadingState extends RequestState {}

class ErrorState extends RequestState {
  final String? message;

  ErrorState({this.message});
}

class SuccessState extends RequestState {}
