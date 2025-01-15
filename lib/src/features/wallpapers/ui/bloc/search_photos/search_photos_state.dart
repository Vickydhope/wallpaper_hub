part of 'search_photos_bloc.dart';

class SearchPhotosState {
  List<PhotoEntity> photos = [];
  final ApiState apiState;
  final String query;

  SearchPhotosState(
      {List<PhotoEntity>? photos, ApiState? apiState, String? query})
      : photos = photos ?? [],
        apiState = apiState ?? InitialState(),
        query = query ?? '';

  SearchPhotosState copyWith(
          {List<PhotoEntity>? photos, ApiState? apiState, String? query}) =>
      SearchPhotosState(
        photos: photos ?? this.photos,
        query: query ?? this.query,
        apiState: apiState ?? this.apiState,
      );
}
