part of 'curated_photos_bloc.dart';

@immutable
abstract class CuratedPhotosEvent {}

class GetCuratedPhotosEvent extends CuratedPhotosEvent {
  final bool refresh;

  GetCuratedPhotosEvent({
    this.refresh = false,
  });
}
