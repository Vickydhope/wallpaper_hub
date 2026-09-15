part of 'download_photo_bloc.dart';

@immutable
class DownloadPhotoState {
  final RequestState downloadState;

  DownloadPhotoState({RequestState? downloadState})
      : downloadState = downloadState ?? InitialState();

  DownloadPhotoState copyWith({RequestState? downloadState}) =>
      DownloadPhotoState(downloadState: downloadState);
}
