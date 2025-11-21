part of 'curated_photos_bloc.dart';

class CuratedPhotosState {
  List<PhotoEntity> photos = [];
  final ApiState apiState;
  final String query;

  CuratedPhotosState({
    List<PhotoEntity>? photos,
    ApiState? apiState,
    String? query,
  })  : photos = photos ?? [],
        query = query ?? '',
        apiState = apiState ?? InitialState();

  CuratedPhotosState copyWith({
    List<PhotoEntity>? photos,
    ApiState? apiState,
    String? query,
  }) =>
      CuratedPhotosState(
        query: query ?? this.query,
        photos: photos ?? this.photos,
        apiState: apiState ?? this.apiState,
      );
}
