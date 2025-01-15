part of 'search_photos_bloc.dart';

@immutable
abstract class SearchPhotosEvent {}

class SearchPhotos extends SearchPhotosEvent {
  final bool refresh;

  SearchPhotos({
    this.refresh = false,
  });
}

class SearchQueryChange extends SearchPhotosEvent {
  final String query;

  SearchQueryChange({
    required this.query,
  });
}
