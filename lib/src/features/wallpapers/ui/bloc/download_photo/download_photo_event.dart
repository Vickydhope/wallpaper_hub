part of 'download_photo_bloc.dart';

@immutable
abstract class DownloadPhotoEvent {}

class DownloadPhoto extends DownloadPhotoEvent{
  final String photoUrl;

  DownloadPhoto({required this.photoUrl});
}
