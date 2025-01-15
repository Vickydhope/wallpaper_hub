import 'package:wallpaper_hub/src/features/wallpapers/domain/entity/photo_entity.dart';

import '../../../../core/resources/data_state.dart';

abstract class WallpaperRepository {

  Future<DataState<List<PhotoEntity>>> getCuratedPhotos({
    required int page,
    required int perPage,
  });

  Future<DataState<List<PhotoEntity>>> searchPhotos({
    required String query,
    required int page,
    required int perPage,
  });
}
