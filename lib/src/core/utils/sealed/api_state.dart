sealed class ApiState {}

class InitialState extends ApiState {}

class LoadingState extends ApiState {}

class ErrorState extends ApiState {
  final String? message;

  ErrorState({this.message});
}

class SuccessState extends ApiState {}
