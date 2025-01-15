import 'package:injectable/injectable.dart';
import 'package:wallpaper_hub/src/core/utils/usecase/usecase.dart';
import 'package:wallpaper_hub/src/features/wallpapers/domain/entity/photo_entity.dart';
import 'package:wallpaper_hub/src/features/wallpapers/domain/repository/wallpaper_repository.dart';

import '../../../../core/resources/data_state.dart';

@injectable
class SearchPhotosUseCase
    implements UseCase<DataState<List<PhotoEntity>>, SearchPhotosParams> {
  final WallpaperRepository _wallpaperRepository;

  SearchPhotosUseCase(this._wallpaperRepository);

  @override
  Future<DataState<List<PhotoEntity>>> call({
    required SearchPhotosParams param,
  }) {
    return _wallpaperRepository.searchPhotos(
      query: param.query,
      page: param.page,
      perPage: param.perPage,
    );
  }
}

class SearchPhotosParams {
  final String query;
  final int page, perPage;

  SearchPhotosParams({
    required this.query,
    required this.page,
    required this.perPage,
  });
}
