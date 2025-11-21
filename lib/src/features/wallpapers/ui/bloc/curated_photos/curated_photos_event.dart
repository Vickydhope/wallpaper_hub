part of 'curated_photos_bloc.dart';

@immutable
abstract class CuratedPhotosEvent {}

class GetCuratedPhotosEvent extends CuratedPhotosEvent {
  final bool refresh;

  GetCuratedPhotosEvent({
    this.refresh = false,
  });
}

class SearchPhotosEvent extends CuratedPhotosEvent {
  final bool refresh;

  SearchPhotosEvent({
    this.refresh = false,
  });
}

class SearchQueryChange extends CuratedPhotosEvent {
  final String query;

  SearchQueryChange({
    required this.query,
  });
}
