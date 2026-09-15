part of 'curated_photos_bloc.dart';

class CuratedPhotosState {
  List<PhotoEntity> photos = [];
  final RequestState apiState;
  final String query;

  CuratedPhotosState({
    List<PhotoEntity>? photos,
    RequestState? apiState,
    String? query,
  })  : photos = photos ?? [],
        query = query ?? '',
        apiState = apiState ?? InitialState();

  CuratedPhotosState copyWith({
    List<PhotoEntity>? photos,
    RequestState? apiState,
    String? query,
  }) =>
      CuratedPhotosState(
        query: query ?? this.query,
        photos: photos ?? this.photos,
        apiState: apiState ?? this.apiState,
      );
}
