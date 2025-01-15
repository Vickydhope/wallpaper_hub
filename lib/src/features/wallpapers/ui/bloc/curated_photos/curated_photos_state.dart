part of 'curated_photos_bloc.dart';

class CuratedPhotosState {
  List<PhotoEntity> photos = [];
  final ApiState apiState;

  CuratedPhotosState({
    List<PhotoEntity>? photos,
    ApiState? apiState,
  })  : photos = photos ?? [],
        apiState = apiState ?? InitialState();

  CuratedPhotosState copyWith({
    List<PhotoEntity>? photos,
    ApiState? apiState,
  }) =>
      CuratedPhotosState(
        photos: photos ?? this.photos,
        apiState: apiState ?? this.apiState,
      );
}
