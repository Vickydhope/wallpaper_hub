import 'package:injectable/injectable.dart';
import 'package:wallpaper_hub/src/core/utils/usecase/usecase.dart';
import 'package:wallpaper_hub/src/features/wallpapers/domain/entity/photo_entity.dart';
import 'package:wallpaper_hub/src/features/wallpapers/domain/repository/wallpaper_repository.dart';

import '../../../../core/resources/data_state.dart';

@injectable
class GetCuratedPhotosUseCase implements UseCase<DataState<List<PhotoEntity>>, GetCuratedPhotoParams> {
  final WallpaperRepository _wallpaperRepository;

  GetCuratedPhotosUseCase(this._wallpaperRepository);

  @override
  Future<DataState<List<PhotoEntity>>> call({
    required GetCuratedPhotoParams param,
  }) {
    return _wallpaperRepository.getCuratedPhotos(
      page: param.page,
      perPage: param.perPage,
    );
  }
}

class GetCuratedPhotoParams {
  final int page, perPage;

  GetCuratedPhotoParams({
    required this.page,
    required this.perPage,
  });
}
