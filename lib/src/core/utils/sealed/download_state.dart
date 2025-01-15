sealed class DownloadState {}

class InitialState extends DownloadState {}

class LoadingState extends DownloadState {}

class ErrorState extends DownloadState {
  final String? message;

  ErrorState({this.message});
}

class SuccessState extends DownloadState {}
