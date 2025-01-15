import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:wallpaper_hub/src/core/resources/data_state.dart';
import 'package:wallpaper_hub/src/core/utils/errors/error_handler.dart';
import 'package:wallpaper_hub/src/features/wallpapers/data/datasources/remote/wallpaper_api_service.dart';
import 'package:wallpaper_hub/src/features/wallpapers/domain/entity/photo_entity.dart';
import 'package:wallpaper_hub/src/features/wallpapers/domain/entity/src_entity.dart';
import 'package:wallpaper_hub/src/features/wallpapers/domain/repository/wallpaper_repository.dart';

@Injectable(as: WallpaperRepository)
class WallpaperRepositoryImpl extends WallpaperRepository {
  final WallpaperApiService _wallpaperApiService;

  WallpaperRepositoryImpl(this._wallpaperApiService);

  @override
  Future<DataState<List<PhotoEntity>>> getCuratedPhotos({required int page, required int perPage}) async {
    try {
      var response = await _wallpaperApiService.getCuratedPhotos(page, perPage);
      if (response.response.statusCode == HttpStatus.ok) {
        final photos = response.data.photos?.map((photo) => photo.toEntity()).toList();
        return DataSuccess(photos ?? []);
      }
      return DataFailed(DataSource.DEFAULT.getFailure());
    } catch (error) {
      return DataFailed(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<DataState<List<PhotoEntity>>> searchPhotos({
    required String query,
    required int page,
    required int perPage,
  }) async {
    try {
      var response = await _wallpaperApiService.searchPhotos(query, page, perPage);
      if (response.response.statusCode == HttpStatus.ok) {
        final photos = response.data.photos?.map((photo) => photo.toEntity()).toList();
        return DataSuccess(photos ?? []);
      }
      return DataFailed(DataSource.DEFAULT.getFailure());
    } catch (error) {
      return DataFailed(ErrorHandler.handle(error).failure);
    }
  }
}

