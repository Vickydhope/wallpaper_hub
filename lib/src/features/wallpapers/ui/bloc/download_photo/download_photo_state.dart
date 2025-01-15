part of 'download_photo_bloc.dart';

@immutable
class DownloadPhotoState {
  final DownloadState downloadState;

  DownloadPhotoState({DownloadState? downloadState})
      : downloadState = downloadState ?? InitialState();

  DownloadPhotoState copyWith({DownloadState? downloadState}) =>
      DownloadPhotoState(downloadState: downloadState);
}
